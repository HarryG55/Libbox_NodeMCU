print("Setting Wifi")
wifi.setmode(wifi.STATION)

station_info={}
station_info.ssid="Insprition"
station_info.pwd="P-6h6662"

print("Configurating...")

wifi.sta.config(station_info)

print("Connecting...")

wifi.sta.connect()

-------------------------------------

local info = {}

-- info.SSID = ""
ProductKey="a1EN475h0sh"
ClientId = wifi.sta.getmac()
DeviceName="NodeMCU1"
DeviceSecret="xXu6Y06FCOiOXxylmxdgdFud2hndomOM"
RegionId="cn-shanghai"

myMQTTport=1883 --port
myMQTT=nil  --client

myMQTThost=ProductKey..".iot-as-mqtt."..RegionId..".aliyuncs.com" --host
myMQTTusername=DeviceName.."&"..ProductKey --username

topic0="/a1EN475h0sh/NodeMCU1/user/update"

----------------------------
function GetNetTime()
    sntp.sync({"0.nodemcu.pool.ntp.org","1.nodemcu.pool.ntp.org","2.nodemcu.pool.ntp.org","3.nodemcu.pool.ntp.org","www.beijing-time.org"},
            function(sec, usec, server, info)
                    print('sync', sec, usec, server)       
            end,
            function()
            print("get time error")
            end)  
    return 0
end
----------------------------

myMQTTtimes='6666'
hmacdata="clientId"..ClientId.."deviceName"..DeviceName.."productKey"..ProductKey.."timestamp"..myMQTTtimes
myMQTTpassword=crypto.toHex(crypto.hmac("sha1",hmacdata,DeviceSecret))
myMQTTClientId=ClientId.."|securemode=3,signmethod=hmacsha1,timestamp="..myMQTTtimes.."|"

myMQTT=mqtt.Client(myMQTTClientId,120,myMQTTusername,myMQTTpassword)


--timely connecting 
MQTTconnectFlag=0
tmr.create():alarm(1000,1,function()
    if myMQTT~=nil then
        print("Attempting client connect..")
        myMQTT:connect(myMQTThost,myMQTTport,0,MQTTSuccess,MQTTFailed)
    end

end)

function MQTTSuccess(client)
    print("MQTT connected")
    client:subscribe(topic0,0,function(conn)
        print("subscribe success")
    end)
    myMQTT=client
    MQTTconnectFlag=1
    tmr.stop(0)                 --stop the timer connection
end

function MQTTFailed(client,reason)
    print("Fail reason:"..reason)
    MQTTconnectFlag=0
    tmr.start(0)                --start the timer connection
end

myMQTT:on("offline",function(client)
    print("offline")
    tmr.start(0)
end)

myMQTT:on("message",function(client,topic,data)
    print(topic..":")
    if data ~= nil then
        print(data)
    end
    
end)

tmr.create():alarm(5000,1,function()
    if MQTTconnectFlag==1 and myMQTT~=nil then
        myMQTT:publish(topic0,"this is data upload",0,0,function(client)
            print("send OK")
        end)
    end
end)


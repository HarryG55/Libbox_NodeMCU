
--基本的信息都在这里更改即可
local info = {}

-- info.SSID = ""
info.BROKER_IP = "192.168.1.167"
info.BROKER_PORT = 1980
info.USERNAME = "nodemcu"
info.PASSWORD = "123"
info.ID = node.chipid()

info.subscribe_topic = "/topic"
info.publish_topic = "/topic"
info.publish_message = "hello"


--function(client)表示连接成功的情况
--function(client,reason)表示连接不成功的情况

new = mqtt.Client(info.ID,120,info.USERNAME,info.PASSWORD)

new:on('connect',function(client) print('begin to connected...') end)   --貌似必须传入client

new:on('offline',function(client) print('offline') end)

new:on('message',function(client,topic,data)
    print(topic..":")       --..指的是连接；
        if data ~= nil then
            print(data)     --如果内容非空，则打印内容
        end
end)

-- 0代表不进行安全加密（TLS）

new:connect(info.BROKER_IP,info.BROKER_PORT,0

    ,function(client) 
        print('connect success!') 
        -- 0:Qos level
        new:subscribe(info.subscribe_topic,0,function(client) print("subscribe success") end)
        -- 0:Qos level      0:retain flag
        new:publish(info.publish_topic,info.publish_message,0,0,function(client) print("sent") end)

    ,function(client,reason)
        print("failed connection!reason:"..reason)

end)

new:close()

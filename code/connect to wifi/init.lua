
print("Setting Wifi")
wifi.setmode(wifi.STATION)

station_info={}
station_info.ssid="Isprition"
station_info.pwd="P-6h6662"

print("Configurating...")

wifi.sta.config(station_info)

print("Connecting...")

wifi.sta.connect()
--this need a connection checking program

local sda,scl = 1,2
i2c.setup(0,sda,scl,i2c.SLOW)
bmp085.setup()

local t = bmp085.temperature()
print(string.format("Temprature:%s.%s degrees C",t/10,t%10))

local p =bmp085.pressure()
print(string.format("Pressure:%s.%s mbar",p/100,p%100))

-- 使用Save to ESP 或者其他按键，不断尝试各种键盘
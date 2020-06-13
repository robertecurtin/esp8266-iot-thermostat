### ESP8266-iot-thermistor

Allows the ESP8266 to integrate with a thermistor.

Allows use of [espeon](https://github.com/ryanplusplus/espeon) to transfer files.

espeon hot-fix:
```
git clone https://github.com/nodemcu/nodemcu-firmware
cd nodemcu-firmware
(cd app/lua/luac_cross && make)
cp luac.cross ~/.lenv/lua/5.1.5/lib/luarocks/rocks-5.1/espeon/1.10-0/res/luac.cross-linux
```

Make sure to add your wifi configuration before running.

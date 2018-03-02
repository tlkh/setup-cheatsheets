#!/bin/bash

sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"

sudo echo '35000' > /sys/devices/virtual/thermal/thermal_zone0/trip_point_0_temp
sudo echo "40 100 150 255" > /sys/devices/platform/pwm-fan:/hwmon/hwmon0/fan_speed

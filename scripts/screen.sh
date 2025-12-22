#!/bin/bash

if [[ -e /dev/ttyACM0 ]]; then
    kitty --hold --title "ACM0" screen /dev/ttyACM0 115200 &
fi

if [[ -e /dev/ttyCH343USB0 ]]; then
    kitty --hold --title "CH343USB0" screen /dev/ttyCH343USB0 115200 &
fi

pkill screen
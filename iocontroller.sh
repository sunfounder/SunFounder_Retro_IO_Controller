#!/usr/bash
# -*- coding: utf-8 -*-
KEYS=('up' 'down' 'left' 'right' 'return' 'space' 'ctrl' 'alt' 'z' 'x' 'a' 's' 'esc')
BUTTONS=("D-PAD UP" "D-PAD DOWN" "D-PAD LEFT" "D-PAD RIGHT" "START" "SELECT" "A" "B" "X" "Y" "LEFT SHOULDER" "RIGHT SHOULDER" "Exit")
PINS=(17 18 27 22 23 24 25 4 5 6 13 19 26)

GPIO_PATH='/sys/class/gpio'
button_lenth=${#BUTTONS[@]}

function pin_read(){
    cmd=`cat ${GPIO_PATH}/gpio${1}/value`
    return $((10#${cmd}))
}

# Setup PINS:
for pin in ${PINS[*]}
do
    echo ${pin} > ${GPIO_PATH}/export
    sleep 0.001s
    echo in > ${GPIO_PATH}/gpio${pin}/direction
    sleep 0.001s
    echo high > ${GPIO_PATH}/gpio${pin}/direction
    sleep 0.001s
done


for ((i=0; i<$button_lenth; i ++))
do
    last_pin_state[$i]=1
done

while true
do
    for ((i=0; i<$button_lenth; i ++))
    do
        pin_read ${PINS[$i]}
        current_pin_state=$?
        if [ "$current_pin_state" != "${last_pin_state[$i]}" ]; then
            sleep 0.02s
            if [ "$current_pin_state" != "${last_pin_state[$i]}" ]; then
                if [ "$current_pin_state" = '1' ]; then
                    echo -e "Channel GPIO${PINS[$i]} Released!"
                    #keyboard.release(KEYS[PINS.index($PINS[$i])])
                else
                    echo -e "Channel GPIO${PINS[$i]} Pressed!"
                    #keyboard.press(KEYS[PINS.index($PINS[$i])])
                fi
                last_pin_state[$i]=$current_pin_state
            fi
        fi
    done
    sleep 0.001s
done
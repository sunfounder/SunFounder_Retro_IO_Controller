#!/usr/bin/env python
# -*- coding: utf-8 -*-
import RPi.GPIO as GPIO
import sys
import os
import keyboard
from time import sleep

script_name_full = os.path.realpath(sys.argv[0]) 
config_file = script_name_full.replace('.py', '.conf')

print "Configure file is at:"
print config_file

KEYS    = ['up', 'down', 'left', 'right', 'return', 'space', 'ctrl', 'alt', 'z', 'x', 'a', 's', 'esc']
BUTTONS = ["D-PAD UP", "D-PAD DOWN", "D-PAD LEFT", "D-PAD RIGHT", "START", "SELECT", "A", "B", "X", "Y", "LEFT SHOULDER", "RIGHT SHOULDER", "Exit"]
PINS    = [17, 18, 27, 22, 23, 24, 25, 4, 5, 6, 13, 19, 26]

button_lenth = len(BUTTONS)

def read_config():
    global PINS
    conf = open(config_file,'r')
    lines=conf.readlines()
    conf.close()
    # Find the arguement and set the value
    for i in range(button_lenth):
        for line in lines:
            if line[0] != '#':
                name_value = line.strip().split('=')
                if name_value != ['']:
                    name = name_value[0].strip()
                    value = name_value[1].strip()
                    if name == BUTTONS[i]:
                        #print "found key! key: %s  value: %s" % (key, value)
                        PINS[i] = int(value)
                        break

def setup():
    read_config()
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(PINS, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    #for pin in PINS:
    #    GPIO.add_event_detect(pin, GPIO.BOTH, callback=button_isr, bouncetime=10)#

def button_isr(chn):
    channel_value = GPIO.input(chn)
    print "channel_value = %s" % channel_value
    if channel_value == 0:
        print "Channel GPIO%s Pressed!" % chn
        #keyboard.press(KEYS[PINS.index(chn)])
    else:
        print "Channel GPIO%s Released!" % chn
        #keyboard.release(KEYS[PINS.index(chn)])


def main():
    last_pin_state = []
    for i in PINS:
        last_pin_state.append(1)
    while True:
        for i in range(button_lenth):
            current_pin_state = GPIO.input(PINS[i])
            if current_pin_state != last_pin_state[i]:
                sleep(20/1000.0)
                if current_pin_state != last_pin_state[i]:
                    if current_pin_state:
                        print "Channel GPIO%s Released!" % PINS[i]
                        keyboard.release(KEYS[PINS.index(PINS[i])])
                    else:
                        print "Channel GPIO%s Pressed!" % PINS[i]
                        keyboard.press(KEYS[PINS.index(PINS[i])])
                        #sleep(1)
                    last_pin_state[i] = current_pin_state
    sleep(0.01)

if __name__ == '__main__':
    setup()
    main()

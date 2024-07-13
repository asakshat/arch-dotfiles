#!/bin/bash

options="Color Picker"

selected_option=$(echo -e $options | rofi -dmenu -p "Select an option:")

if [ "$selected_option" == "Color Picker" ]; then
    xcolor --selection | xclip -selection greenclip -t image/png 
fi
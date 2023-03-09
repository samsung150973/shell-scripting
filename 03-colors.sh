#!/bin/bash
#
# For a colored background
# reset = 0, black = 40, red = 41, green = 42, yellow = 43, blue = 44, magenta = 45, cyan = 46, and white=47, are the commonly used color codes.

# For foreground
# reset = 0, black = 30, red = 31, green = 32, yellow = 33, blue = 34, magenta = 35, cyan = 36, and white = 37.

echo -e "\e[31m This is in red Colour \e[0m"
echo -e "\e[32m This is in Green Colour \e[0m"
echo -e "\e[33m This is in yellow Colour \e[0m"
echo -e "\e[34m This is in blue Colour \e[0m"
echo -e "\e[35m This is in magenta Colour \e[0m"
echo -e "\e[36m This is in Cyan Colour \e[0m"
echo -e "\e[37m This is in White Colour \e[0m"
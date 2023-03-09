#!/bin/bash
echo line1
echo line2
echo line2
echo to enable escape sequnce use -e  with options /t /n
echo -e "LineX\tLineY"
echo -e "LineA\nLineB"
echi -e "LINEa\n\tLINEb"
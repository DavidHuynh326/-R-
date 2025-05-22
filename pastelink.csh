#!/bin/csh
echo "**********"
echo "Paste Link"
echo "**********"
set at = "`pwd`"
ll -rlt |awk '{if(NF>2) line[NR]=$NF} END {for (i=2;i<=NR;i++) printf "'$at'/%s\n",line[i]}'

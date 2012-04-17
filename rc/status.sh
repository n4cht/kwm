#!/bin/sh
#  
# 
#
# This Status.sh by Ivo (http://dotshare.it/~ivo/)
  
# Date
 DATE="`date '+%a %d %b %Y'`"
  
# Time 
 HOUR="`date '+%H:%M:%S'`"
  

# Processor Usage
 CPU0=$(eval $(awk '/^cpu0 /{print "previdle=" $5 "; prevtotal=" $2+$3+$4+$5 }' /proc/stat);
          sleep 0.4;
          eval $(awk '/^cpu0 /{print "idle=" $5 "; total=" $2+$3+$4+$5 }' /proc/stat);
          intervaltotal=$((total-${prevtotal:-0}));
          echo "$((100*( (intervaltotal) - ($idle-${previdle:-0}) ) / (intervaltotal) ))")
  	  
# RAM
 MEM="`free -m | grep "buffers/" | awk {'print $3'}`"
  
# Volume - REQUIRES ALSA 
  VOL=`amixer | grep "PCM" -A 5 | grep -o "\[.*%" | sed "s/\[//" | sed 's/%//'` 
 


#
 wmfs -s "\\#80536D\\CPU ¤ \\#262626\\$CPU0%  | \\#80536D\\MEM ¤ \\#262626\\$MEM | \\#80536D\\VOL ¤ \\#262626\\$VOL%\\#262626\\ | \\#80536D\\$DATE \\#262626\\| \\#262626\\$HOUR" 
; If the printer hasn't been homed, home it
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
  M98 P"/sys/homez.g"                 ; call homez
  M98 P"/sys/homex.g"                 ; call homex
  M98 P"/sys/homey.g"                 ; call homey
  
;echo "starting tpre0"
;tool change movement
M564 S0
G1 X{global.model_toggle_pos - 20} F18000
G1 X{global.model_toggle_pos} F1800 ; Model Filament Select *may need to adjust X position based on tool offset!
M400
if sensors.gpIn[4].value = 0
  M564 S1 ; Limit movements to printer limits
  M98 P"/macros/purgepark.g"
  abort "T0 toggle select failed, inspect print head"
M564 S1
;echo "ending tpre0"
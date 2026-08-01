G91
M98 P"/sys/homey.g"                 ; call homey

var y_high_trigger = 0
M950 J6 C"nil"  ; Y-axis EOT unassign
M574 Y2 S1 P"!io4.in"  ; assign Y EOT to x endstop on high side
G1 H4 Y360 F6000
G1 Y-5 F6000
G1 H4 Y10 F360
set var.y_high_trigger = move.axes[1].machinePosition
M574 Y1 S1 P"!io1.in" ;reassign old y home
M950 J6 C"!io4.in"      ; y-axis EOT

G90
M98 P"/macros/purgepark.g"
echo "Y High Value:" ^ var.y_high_trigger
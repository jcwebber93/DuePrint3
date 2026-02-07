if sensors.gpIn[3].value = 1
    T0

G91     ;relative positioning
M98 P"/sys/homex.g"                 ; call homex
;G1 X10 F6000

var support_trigger = 0
M950 J3 C"nil"      ;Unassign toggle support sensor
M574 X1 S1 P"124.pa04"                 ; X home limit (low side)
G1 H4 X-80 F360
set var.support_trigger = move.axes[0].machinePosition
M574 X1 S1 P"!io0.in" ;reassign original x home
M950 J3 C"124.pa04"      ;Reassign toggle support sensor

var x_high_trigger = 0
M950 J5 C"nil"  ; X-axis EOT unassign
M574 X2 S1 P"!io3.in"  ; assign X EOT to x endstop on high side
G1 H4 X500 F6000
G1 X-5 F6000
G1 H4 X10 F360
set var.x_high_trigger = move.axes[0].machinePosition
M574 X1 S1 P"!io0.in" ;reassign old x home
M950 J5 C"!io3.in"      ; X-axis EOT

var model_trigger = 0
M950 J4 C"nil"      ;Unassign toggle model sensor
M574 X2 S1 P"124.pb08"  ; assign model toggle to x endstop on high side
G1 H4 X80 F360
set var.model_trigger = move.axes[0].machinePosition
M574 X1 S1 P"!io0.in" ;reassign original x home
M950 J4 C"124.pb08"     ;Reassign toggle model sensor

G90

M98 P"/macros/purgepark.g"

echo "Support Toggle Value:" ^ var.support_trigger ^ ", X High Value:" ^ var.x_high_trigger ^ ", Model Toggle Value:" ^ var.model_trigger
T-1
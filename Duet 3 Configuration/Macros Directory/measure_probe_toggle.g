if !move.axes[0].homed || !move.axes[1].homed	        ; If the printer hasn't been homed, home it
	G28 XY	                                             ; home X, Y. Z will be homed if its not during X homing script

M564 S0 ; Allow movement beyond printer limits
G1 X-100 Y178.5 F18000; Move to back of Printer

G91     ;relative positioning

var deploy_trigger = 0
M558 P5 C"nil"						;Unassign Z-Probe
M574 X1 S1 P"io2.in"                 ; X home limit (low side) note that the input is not inverted for this measurement!
G1 H4 X-150 F1800
set var.deploy_trigger = move.axes[0].machinePosition
;M574 X1 S1 P"!io0.in" ;reassign original x home

var retract_trigger = 0
M574 X2 S1 P"!io2.in" 		; assign X EOT to x endstop on high side, invert input
G1 H4 X500 F1800
set var.retract_trigger = move.axes[0].machinePosition
M574 X1 S1 P"!io0.in" ;reassign old x home
M558 P5 C"!io2.in" ; Z probe, set dive height, probe speed and travel speed

G90

M98 P"/macros/purgepark.g"
M564 S1			;Restrict movement to axis limits

echo "Deploy Position:" ^ var.deploy_trigger ^ ", Retract Position:" ^ var.retract_trigger
T-1

G91
if global.home_zmax = true
	set global.home_zmax = false
M98 P"/sys/homez.g"                 ; call homez

var z_high_trigger = 0
if sensors.endstops[2].triggered = true       ; if we're hard against the endstop we need to move away
	M564 H0 S0
	G1 Z-20 F1200
	M564 H1 S1
	M400
	if sensors.endstops[2].triggered = true
		G90
		abort "Z Endstop appears to be faulty.  Still in triggered state."
G1 H4 Z335 F1200                              ;Home to bottom of printer
if result != 0
	G90
	abort "Print cancelled due to error during fast homing"
G1 Z-5 F1200
G1 H4 Z7 F360
if result != 0
	G90
	abort "Print cancelled due to error during slow homing"
set var.z_high_trigger = move.axes[2].machinePosition

G90
M98 P"/macros/purgepark.g"

G91

var z_low_trigger = 0
M950 J7 C"nil"  ; Z-axis top of printer unassign
M574 Z0         ;unassign Z-axis home
M574 Z1 S1 P"!io5.in"  ; assign Z EOT to x endstop on high side
G1 H4 Z-333 F1200
G1 Z5 F1200
G1 H4 Z-7 F360

set var.z_low_trigger = move.axes[2].machinePosition

M574 Z0         ;unassign Z-axis home
M574 Z2 S1 P"!io6.in"          ; reassign Z home
M950 J7 C"!io5.in"      ; z-axis top of printer
M208 Z{move.axes[2].machinePosition} S1
G90
echo "Z High Value:" ^ var.z_high_trigger  ^ ", Z Low Value:" ^ var.z_low_trigger


G91                                         ; relative positioning
if sensors.gpIn[7].value = 1
	echo "Moving Z to safe position."
	G1 Z20 F1200
	M400
	if sensors.gpIn[7].value = 1
		G90
		abort "Failed to move Z to safe position."                                          ; home z
T-1 P0; Deselect Tool

if sensors.endstops[1].triggered = true     ; if we're hard against the endstop we need to move away
	M564 H0 S0
	G1 Y50 F1200
	M564 H1 S1
	M400
	if sensors.endstops[1].triggered = true
		G90
		abort "Y Endstop appears to be faulty.  Still in triggered state."
G1 H1 Y-355 F6000                            ; move quickly to X axis endstop and stop there (first pass)
if result != 0
	G90
	abort "Print cancelled due error during fast homing"
G1 Y5 F6000                                ; go back a few mm
G1 H1 Y-355 F360                             ; move slowly to X axis endstop once more (second pass)
if result != 0
	G90
	abort "Print cancelled due to error during slow homing"
G1 Y5 F6000                                ; go back a few mm
G90                                         ; absolute positioning
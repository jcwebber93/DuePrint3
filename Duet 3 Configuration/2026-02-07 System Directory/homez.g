G91                                           ; relative positioning
T-1 P0
if global.home_zmax = true
	echo "Not skipping Z-max homing"
	if sensors.endstops[2].triggered = true       ; if we're hard against the endstop we need to move away
		M564 H0 S0
		G1 Z-20 F1200
		M564 H1 S1
		M400
		if sensors.endstops[2].triggered = true
			G90
			abort "Z Endstop appears to be faulty.  Still in triggered state."
	G1 H1 Z335 F1200                              ;Home to bottom of printer
	if result != 0
		G90
		abort "Print cancelled due to error during fast homing"
	G1 Z-5 F1200
	G1 H1 Z7 F360
	if result != 0
		G90
		abort "Print cancelled due to error during slow homing"
	;set global.home_zmax = true			; set to true
else
	echo "Skipping Z-max homing"
G90                                           ; absolute positioning

M401		;deploy probe
if global.home_zmax = true
	var p0trigger = 0
	G30 P0 X0 Y0 Z-99999
	set var.p0trigger = sensors.probes[0].lastStopHeight
	echo {var.p0trigger - sensors.probes[0].triggerHeight} ^ " probe delta"  
	M208 Z{sensors.probes[0].triggerHeight - sensors.probes[0].lastStopHeight + move.axes[2].max} S0
	G92 Z{move.axes[2].machinePosition + sensors.probes[0].triggerHeight - sensors.probes[0].lastStopHeight}
	set global.home_zmax = false			; set to true
else
	if move.axes[2].machinePosition < 25
		M564 H0 ;allow movement
		G1 Z25
		M564 H1 ; forbid movement of unhomed axes
	G1 X{-sensors.probes[0].offsets[0]} Y{-sensors.probes[0].offsets[1]} F12000 ; go to first probe point
	G30         ;probe

if global.preprint_macro = false
	;echo "storing probe"
	M402		;store probe
	G1 Z100 F1200                                 ;Go to middleish of chamber
else
	echo "Skipping Z100 move"; 
	set global.deploy_probe = false
	;echo global.deploy_probe
	;G4 S5
	M400
	M402

if global.deploy_probe = true
	if !move.axes[0].homed || !move.axes[1].homed	        ; If the printer hasn't been homed, home it
		G28 XY	                                             ; home X, Y. Z will be homed if its not during X homing script
	T-1			; Deselect Tool
	echo "deploying probe"
	M564 S0 ; Allow movement beyond printer limits
	G1 X{global.probe_deploy_pos + 22} Y{global.probe_deploy_y} F18000; Move to back of Printer
	;G1 X-157.3 F1800; Deploy Z-probe
	G1 X{global.probe_deploy_pos - 13} F1800; Deploy Z-probe
	G1 X-100 F18000
	M400
	if sensors.probes[0].value[0] = 1000
		M564 S1 ; Limit movements to printer limits
		abort "Z-Probe appears to be faulty"
	M564 S1 ; Limit movements to printer limits
	echo "deploy complete"
else
	;G4 S5
	echo "already deployed"
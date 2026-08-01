;echo "starting tfree1"
M83 ; relative extruder mode
if (heat.heaters[2].active) > 280
    ;G1 E-.5 F2500 ; retract 2mm
    G91 ; relative axis movement
    G1 Z1 F1200 ; up 1mm
    G90 ; absolute axis movement
M42 P1 S0 ; Disable extruder motor
;echo "ending tfree1"
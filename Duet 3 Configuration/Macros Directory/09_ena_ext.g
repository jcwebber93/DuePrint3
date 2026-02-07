if state.gpOut[1].pwm == 0
    M42 P1 S1
    echo "Extruder On"
else
    M42 P1 S0
    echo "Extruder Off"
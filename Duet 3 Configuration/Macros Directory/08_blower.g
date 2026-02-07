;M950 P0 C"!out4"
;M42 P0 S0 
if state.gpOut[0].pwm == 0
    M42 P0 S1
    echo "Blower Off"
else
    M42 P0 S0
    echo "Blower On"
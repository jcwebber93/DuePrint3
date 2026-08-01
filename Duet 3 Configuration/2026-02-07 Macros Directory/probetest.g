M401
G1 X{sensors.probes[0].offsets[0]} Y{sensors.probes[0].offsets[1]} F12000 ; go to first probe point
G30 S-1         ;probe
G1 Z10
M402
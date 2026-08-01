M564 S0 ; Allow movement beyond printer limits
G1 X-100 Y178.5 F12000; Move to back of Printer
G1 X-157.3 F1800; Drop Z-probe
G1 X-100 F12000
M564 S1 ; Limit movements to printer limits

G29 S0

M564 S0 ; Allow movement beyond printer limits
G1 Z50 F1200
G1 X0 F6000 ; extra move for switch safety
G1 X100 Y178.5 F6000 ; Move to back of Printer
G1 X176.7 F1800; Lift Z-probe
G1 X166.7 Y 138.5 F12000
G1 X185.2 F1800 ; Model Filament Select *may need to adjust X position based on tool offset!
M564 S1 ; Limit movements to printer limits

G1 X0 Y0 F12000; Center tool head
; Enable network
if {network.interfaces[0].type = "ethernet"}
    M552 P0.0.0.0 S1			; enable DHCP for ethernet
else
    M552 I1 S1

M552 I1 S1                            ; enable wifi

G4 S5                                 ;wait for expansion boards to start
M550 P"DuePrint3 BST 1200es"

; Drives
M569 P0 S1                            ;physical drive 0 goes backwards, X-Axis
M569 P1 S0                            ;physical drive 1 goes forwards, Y-Axis
M569 P2 S1                            ;physical drive 2 goes forwards, Z-Axis
M569 P124.0 S0 T0:0:0:0               ;external driver on sammy 12/7 latest
M584 X0 Y1 Z2 E124.0                  ;set drive mapping
M350 X16 Y16 Z16 E16 I1               ;configure microstepping with interpolation
M92 X53.33 Y134 Z629.864 E323.08     ;set steps per mm was 1011.99 then 1594.6, then 642.61
M566 X400 Y400 Z30 E3000              ;set jerk E was 60, x and y was 600
M203 X30000 Y18000 Z1200 E2700.00      ;set max speeds (mm/min)
M201 X2000 Y2000 Z1000 E3000            ;set max accelerations (mm/s^2) X and Y were both 2500 and 3500 E was 2000
M201.1 X750 Y750 Z2000 E3000            ;max special acceleration move (homing)
M906 X1800 Y2600 Z2600 I30            ;set motor currents (mA) and motor idle percent
M84 S30                               ;set idle timeout

M208 X-138.3 Y-137.5 Z-2 S1           ;set axis minima
M208 X160.4 Y182 Z325.2 S0              ;set axis maxima
; Toggle nozzle min - -163.2 , 184.6 max
; X EOT toggles at 160.5
; Y EOT at 182.5
; Z High (bottom) at 325.5, low EOT at -4.6
;purge bucket near middle - x162.5, y155.5

;z probe left toggle -136.5
;z probe right toggle 197.5

;Z bottom (EOT) 325.1



;Endstops

M574 X1 S1 P"!io0.in"                 ; X home limit (low side)
M574 Y1 S1 P"!io1.in"                 ; Y home limit (low side, toward front of printer
M574 Z2 S1 P"!io6.in"                   ; assign Z EOT to x endstop on high side


; Z-Probe
M558 P5 H5 F1200:200 T18000 A3 C"!io2.in" ; Z probe, set dive height, probe speed and travel speed
;G31 P1000 X-46 Y-74 Z0.896
;G31 P1000 X-24 Y-73 Z1.365
;G31 P1000 X24 Y73 Z1.9                    ;Increase value to bring it closer to the bed, decrease to move it away
G31 P1000 X24 Y73 Z2.1                    ;Increase value to bring it closer to the bed, decrease to move it away UPDATED 01/04 
;G31 P1000 X24 Y96 Z0.896                          ; set Z probe trigger value, offset and trigger height
;M557 X-135:135 Y-135:65 P5:5          ; define mesh grid. The whole bead cannot be probed due to the position of the probe.
;M557 X-134:140 Y-127:146.82 P3:3          ; define mesh grid. The whole bead cannot be probed due to the position of the probe. Changed 11/15/2025
M557 X-134:140 Y-127:140 P3:3          ; define mesh grid. The whole bead cannot be probed due to the position of the probe.

; Head Blower Fan
M950 P0 C"io2.out"
M42 P0 S0                             ; enable blower

; Extruder Motor Enable
M950 P1 C"io3.out"
M42 P1 S0

; Touch Power Enable
M950 P2 C"124.pa25"
M42 P2 S0

; Door Enable
M950 P3 C"io6.out"
M42 P3 S0

; LED Lights Enable
M950 P4 C"124.pa24"
M42 P4 S0                             ;S1 to turn on!

; 120v ON
M950 P5 C"io0.out"
M42 P5 S0                   ; LETS START WITH S0 TO BE OFF?

; CONTROLLED POWER SHUTDOWN ENABLE
M950 P6 C"io1.out"
M42 P6 S0                   ; LETS START WITH S0 TO BE OFF?

; DISABLE OUTPUTS
M950 P7 C"!out4"
M42 P7 S1                   ; S1 OUTPUTS DISABLED


; Thermocouples
M308 S0 A"Chamber Test" P"temp0" Y"linear-analog" F0 B-42 C113
M308 S1 A"Model Test" P"temp1" Y"linear-analog" F0 B12.5 C328
M308 S2 A"Support Test" P"temp2" Y"linear-analog" F0 B12.5 C328

; Heaters
M140 H-1                              ;Disable bed heater
M950 H0 C"io4.out" T0                   ; chamber, sensor 0
M141 H0                               ; map chamber to heater 0
M143 H0 S85                           ; set temperature limit for heater 0 to 85C
M570 H0 P60 T10                       ; Increase fault delay to 30s, decrease temperature fault to 10c
M950 H1 C"io5.out" T1                   ; model, sensor 1
M143 H1 S320
M570 H1 P30                           ; set fault time delay to 30s for heater 1
M950 H2 C"io7.out" T2                   ; support, sensor 2
M143 H2 S320                          ; set temperature limit for heater 1 to 320C
M570 H2 P30                           ; set fault time delay to 30s for heater 2

; Tools
M563 P0 S"Model" D0 H1                ; define tool 0
G10 P0 X0 Y0 Z0                       ; set tool 0 axis offsets
G10 P0 R0 S0                          ; set initial tool 0 active and standby temperatures

M563 P1 S"Support" D0 H2              ; define tool 1
G10 P1 X-20.3 Y0 Z-0.025                    ; set tool 1 axis offsets
G10 P1 R0 S0                          ; set initial tool 1 active and standby temperatures

; Head Thermostat Status
M950 J1 C"124.pa06"

; Door In
M950 J2 C"124.pa05"

; Print Head Support Toggle
M950 J3 C"124.pa04"

; Print Head Model Toggle
M950 J4 C"124.pb08"

; X-axis EOT
M950 J5 C"!io3.in"

; Y-axis EOT
M950 J6 C"!io4.in"

; Z-axis Home
M950 J7 C"!io5.in"

; Z-axis EOT
;M950 J8 C"!io6.in"

; Print Head Temp Alarm
M950 J9 C"!io7.in"

; Chamber Temp Alarm
M950 J10 C"124.pa07"

;POWER SWITCH
M950 J11 C"io8.in"

M955 P120.0 I01
M501                                  ;config g
M302 S280 R280
M572 D0 S.065
M593 P"zvdd" F43
M207 P0 S0.35 Z.35 F2700
M207 P1 S0.35 Z.35 F2700
M98 P"globals.g"
M98 P"/macros/startup.g"
M912 P0 S-14

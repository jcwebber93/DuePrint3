# DuePrint3
Duet 3 to Stratasys PDB Interface Board. Used to convert a Stratasys Prodigy series printer (Dimension, uPrint, Fortus 250) to use a modern control board & firmware. This conversion is fully reversable (assuming the printer functions to begin with). Many thanks to AJ Quick and Archeantus (Jeremy) for their past efforts in detailing the electronics of the Dimension/uPrint machines, as well as sharing details on their Duet 2 WiFi conversions.
* https://wiki.cnc.xyz/Stratasys_uPrint_Retrofit
* https://forum.duet3d.com/topic/12647/another-stratasys-uprint-retrofit

[Additional details for this project on the Duet3D forums.](https://forum.duet3d.com/topic/37434/dueprint-with-a-duet-3-6hc-stratasys-dimension-conversion)

![DuetPrint3 Block Diagram](https://github.com/user-attachments/assets/1f5f1e5e-7aae-4b68-a344-b45f1ace6437)

![IMG_4153(1)](https://github.com/user-attachments/assets/9f76785b-ccd1-4d5e-85d1-df155eae5986)

![DuePrint3 v2 5 0](https://github.com/user-attachments/assets/5be43800-c8c7-4db9-b034-4433d7e58bfc)


At present, the implementation focuses on the Dimension 1200es printers (the implementations linked above focus on the uPrint series, which is quite similar. The electronics are laid out a touch differently, meaning the layout of the new hardware must change, as well where the stepper motor wiring taps in to the existing harness). The Duet 3 Mainboard 6HC, as well as the DP3EXB module (natively running RepRapFirmware/Duet3Expansion) interface with 17 inputs, and 11 outputs.
### Inputs
|Device|RRF Pin Name|Function|Gcode|Dependancy|Note|
|---|---|---|---|---|---|
|6HC HEADER 7|io2.in|PRINT BED TOUCH PR LIM SW|`M558 P5 H5 F1200:200 T18000 A3 C"!io2.in" ; Z probe`||Used for Z probing|
|6HC HEADER 9|io6.in|Z-AXIS EOT|`M574 Z2 S1 P"!io6.in" ; Z EOT to Z endstop on high side`||Remapped as part of Z homing routine|
|6HC HEADER 11|io4.in|Y-AXIS EOT|`M950 J6 C"!io4.in" ; Y EOT (High, Back)`||Used for Y end of travel (high side, back of printer)|
|6HC HEADER 13|io3.in|X-AXIS EOT|`M950 J5 C"!io3.in" ; X EOT (High)`||Used for X end of travel|
|6HC HEADER 15|io0.in|X-AXIS HOME SW|`M574 X1 S1 P"!io0.in" ; X home limit (low side)`||Used for X homing (low side)|
|6HC HEADER 17|io1.in|Y-AXIS HOME SW|`M574 Y1 S1 P"!io1.in" ; Y home limit (low side, front of printer)`||Used for Y homing (low side, front of printer)|
|6HC HEADER 19|io5.in|Z-AXIS HOME SW|`M950 J7 C"!io5.in" ; Z Home`||Remapped as part of Z homing routine|
|6HC HEADER 21|io8.in|POWER I/O|`M950 J11 C"io8.in" ; Power Switch Status`||Front power switch status|
|6HC HEADER 23|io7.in|PRINT HEAD TEMP ALARM|`M950 J9 C"!io7.in" ; Print Head Temp Alarm`||Print head temperature alarm|
|DP3EXB |PA07|CHAMBER TEMP ALARM|`M950 J10 C"124.pa07" ; Chamber Temp Alarm`||Chamber temperature alarm|
|DP3EXB |PA06|HEAD THERMOSTAT STATUS|`M950 J1 C"124.pa06" ; Head Thermostat`||Head thermostat|
|DP3EXB |PA05|DOOR SWITCH|`M950 J2 C"124.pa05" ; Door Status`||Door switch status|
|DP3EXB |PA04|SUPPORT TOGGLE SW|`M950 J3 C"124.pa04" ; T1 Toggle`||T1 (Support) toggle sensor|
|DP3EXB |PB11|MODEL TOGGLE SW|`M950 J4 C"124.pb08" ; T0 toggle`||T0 (Model) toggle sensor|
|6HC HEADER 18&20|temp0&VSSA|CHAMBER THERM|`M308 S0 A"Chamber" P"temp0" Y"linear-analog" F0 B-42 C113 ; Chamber Temp Sensor`||Chamber temperature sensor|
|6HC HEADER 22&24|temp2&VSSA|SUPPORT THERM|`M308 S1 A"Model" P"temp1" Y"linear-analog" F0 B12.5 C328 ; T1 (Support) Temp Sensor`||Tool 1 (Support) temperature sensor|
|6HC HEADER 26&28|temp1&VSSA|MODEL THERM|`M308 S2 A"Support" P"temp2" Y"linear-analog" F0 B12.5 C328 ; T0 (Model) Temp Sensor`||Tool 0 (Model) temperature sensor|



### Outputs
|Device|RRF Pin Name|Function|Gcode|Dependancy|Note|
|---|---|---|---|---|---|
|6HC HEADER 2|io0.out|120V ON|`M950 P5 C"io0.out" ; 120V On`|Outputs need to be enabled via "M42 P7 S0"|Enables 120V power supplies|
|6HC HEADER 3|out4|48V RTN|`M950 P7 C"!out4"  ; Disable Outputs`||This provides power to DuePrint3 level shifters.|
|6HC HEADER 4|io1.out|POWER ON|`M950 P6 C"io1.out" ; Controlled Shutdown`|Outputs need to be enabled via "M42 P7 S0"|When enabled, allows the printer to handle a controlled shutdown when front power switch is toggled|
|6HC HEADER 6|io3.out|MOTOR ENA|`M950 P1 C"io3.out" ;Extruder Motor`|Outputs need to be enabled via "M42 P7 S0"|Enables the extruder motor|
|6HC HEADER 8|io4.out|CHAMBER HEATER ENA|`M950 H0 C"io4.out" T0 ; Chamber heater, Sensor 0`|Outputs need to be enabled via "M42 P7 S0"|Chamber heater|
|6HC HEADER 10|io2.out|BLOWER ENA|`M950 P0 C"io2.out" ; Head Blower Fan`|Outputs need to be enabled via "M42 P7 S0"|Used to enable or disable head blower fan|
|6HC HEADER 12|io7.out|SUPPORT HEATER ENA|`M950 H2 C"io7.out" T2 ; T1 heater, Sensor 2`|Outputs need to be enabled via "M42 P7 S0"|Tool 1 (Support) heater|
|6HC HEADER 14|io5.out|EXTRUDER MODEL HEATER ENA|`M950 H1 C"io5.out" T1 ; T0 heater, Sensor 1`|Outputs need to be enabled via "M42 P7 S0"|Tool 0 (Model) heater|
|6HC HEADER 16|io6.out|DOOR SOLENOID ENA|`M950 P3 C"io6.out" ; Door Lock`|Outputs need to be enabled via "M42 P7 S0"|Used to enable or disable the door lock|
|DP3EXB |PA08|LED LIGHTS ENA|`M950 P4 C"124.pa24" ; Chamber Lights`||Used to enable or disable chamber lights|
|DP3EXB |PA10|PRINT BED TOUCH PR ENA|`M950 P2 C"124.pa25" ;Doesn't seem to function?`||Does not seem to have a function|

### Other
|Header Pin|Desc.|Label|
|---|---|---|
|6HC HEADER 1|N/A|NC|
|6HC HEADER 5|N/A|48V|
|6HC HEADER 25|N/A|NC|
|6HC HEADER 27|N/A|5V|
|6HC HEADER 29|N/A|GND|
|6HC HEADER 30|N/A|GND|


### Spares Header
|Header Pin|Desc.|Label|
|---|---|---|
|SPARE 1||GND|
|SPARE 2|PA27|SPR4|
|SPARE 3|PA02|SPR1|
|SPARE 4|PA23|SPR3|
|SPARE 5|PA01|SPR2|
|SPARE 6|PA19|I_SPR2|
|SPARE 7|PA12|I_SPR1|
|SPARE 8|PA17|SPR5|
|SPARE 9||5V|
|SPARE 10|PA09|SPR6|
|SPARE 11||GND|
|SPARE 12|PA11|SPR7|
|SPARE 13||12V|
|SPARE 14|PA18|SPR8|


The 6HC directly drives the X, Y, and Z stepper motors (vs. controlling them through the Stratasys PDB). The 6HC, unlike the Duet2 (and Duex boards) does not natively have STEP/DIR pins used to emit step and direction pulses. Instead, a DP3EXB expansion board running a fork of Duet3Expansion is used to natively control the extruder's closed loop DC motor. The extruder can be tuned via the ClosedLoopTuning plugin for DWC, with the motor parameters being configured in Config.g. RRF is able to monitor the motor for position errors.

## Materials
[A detailed BOM can be found here](https://github.com/jcwebber93/DuePrint3/blob/v2.5.0/DuePrint3%20BOM.xlsx), with the approximate cost being ~$500 (60% of this is Duet3D 6HC and Sammy-C21).

## Interface Board Design
[The KidCad project for the DuePrint3 board can be found here](https://github.com/jcwebber93/DuePrint3/tree/v2.5.0/DuePrint3%20KiCad%20Project)

## Wiring
[A detailed wire list can be found here.](https://github.com/jcwebber93/DuePrint3/blob/v2.5.0/DuePrint3%20Wire%20List.xlsx) Connectors & crimps for the Duet 3 6HC are supplied with the board, but are JST VH (stepper motors) and Molex KK / Wurth WR-WTB (Wurth connectors/contacts are supplied with Duet Boards). The interface board 6HC and spares header are JST PHD, and spare 5v and 12v headers are Molex Micro-3.0 series connectors & crimps. The headers for the PBD ribbon cables are Samtec EHT series headers.

## DP3EXB Prep
DP3EXB prep to detailed

## Interface Board Prep
If the Interface Board (w/Sammy-C21) is the only CAN-FD device, aside from the Duet 3 6HC, place a 2-socket jumper on J13 as indicated to enable the CAN-FD termination resistor.

<img src="https://github.com/user-attachments/assets/13e7a629-ded0-4cb1-a02a-859b08c741d1" width="700">


J11 connects to the 6HC. J12 can be used with additional expansion boards (such as a Duet 3 SZP on the print head, which could be used as an accelerometer or for bed scanning), provided the CAN-FD bus is terminated on the additional board.

## RepRapFirmware Prep
At present, the 6HC and DP3EXB are running a fork of 3.6.3 (to be documented). [Configuration files are located here](https://github.com/jcwebber93/DuePrint3/tree/v2.0.0/Duet%203%20Configuration/System%20Directory), and [Macros are located here.](https://github.com/jcwebber93/DuePrint3/tree/v2.0.0/Duet%203%20Configuration/Macros%20Directory)

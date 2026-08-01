; When using a macro as custom gcode, do not use G, M, N or T as parameters in a custom 'G' gcode file
; param.A is Chamber Temperature
; param.B is the Initial Extruder (Tool) number
; param.C is the Initial material print temperature
; param.D is second tool (not strictly T1 or T0) standby temp
T-1 P0 
echo "start print macro"	
set global.home_zmax = true				
set global.preprint_macro = true
;M98 P"0:/macros/LED/LED 100%"                                               ; turn on the LED

M141 S{param.A}															; set Chamber Temperature to whatever is set in slicer
M191 S{param.A-2}

M568 P{param.B} S{param.C} A2										; set initial tool print temperature, set to active
if {param.D} > 0
    M568 P1 R{param.D} A1
   
G28                                                                       ; home the printer
M400
M98 P"/macros/ProbeAvgZ.g"
M400
M116 P0                                                                     ; wait for this temperature to be reached
set global.preprint_macro = false			;end of preprint
M400

;Example below is how this relates to my Cura start gcode
;M83

;M98 P"start_print.g" A{build_volume_temperature} B{initial_extruder_nr} C{material_print_temperature_layer_0, initial_extruder_nr} D{material_standby_temperature, 1}
;T{initial_extruder_nr}

;Diagnostic Info
;{material_print_temperature_layer_0, 0}
;{material_print_temperature_layer_0, 1}
;{material_standby_temperature, 0}
;{material_standby_temperature, 1}


;This then turns into the following when the GCODE is created and saved:
;M83

;M98 P"start_print.g" A75 B0 C305 D160
;T0

;Diagnostic Info
;305
;305
;200
;160
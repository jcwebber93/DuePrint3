;M557 X-134:134 Y-64.5:135.5 P10:10
var p0trigger = 0
var p1trigger = 0
var p2trigger = 0
var p3trigger = 0
var p4trigger = 0
G29 S2		;disable and clear bed mesh
M561		;clear mesh transform, not needed likely
M290 R0 S0		; clear babysteping
;if global.deploy_probe = true
;	M401  ;deploy probe if not deployed
M401
if global.preprint_macro = false
	G1 X{-sensors.probes[0].offsets[0]} Y{-sensors.probes[0].offsets[1]} F12000 ; go to first probe point
	G30         ;probe
else
	echo "skipping first probe point"
;M400
set var.p2trigger = sensors.probes[0].lastStopHeight
G30 P0 X-100 Y-64.5 Z-99999
;M400
set var.p0trigger = sensors.probes[0].lastStopHeight
G30 P0 X100 Y-64.5 Z-99999
;M400
set var.p1trigger = sensors.probes[0].lastStopHeight
G30 P0 X100 Y64.5 Z-99999
;M400
set var.p3trigger = sensors.probes[0].lastStopHeight
G30 P0 X-100 Y64.5 Z-99999
;M400
set var.p4trigger = sensors.probes[0].lastStopHeight
if global.deploy_probe = false
	set global.deploy_probe = true
M402		; stow probe
M98 P"/macros/purgepark.g"

var p0d = var.p0trigger + sensors.probes[0].offsets[2]
var p1d = var.p1trigger + sensors.probes[0].offsets[2]
var p2d = var.p2trigger + sensors.probes[0].offsets[2]
var p3d = var.p3trigger + sensors.probes[0].offsets[2]
var p4d = var.p4trigger + sensors.probes[0].offsets[2]

echo var.p0d ^ "," ^ var.p1d ^ "," ^ var.p2d ^ "," ^ var.p3d ^ "," ^ var.p4d
var deltah = 0
set var.deltah =  {{var.p0d}+{var.p1d}+{var.p2d}+{var.p3d}+{var.p4d}}/5
echo var.deltah
G92 Z{move.axes[2].machinePosition + var.deltah} 
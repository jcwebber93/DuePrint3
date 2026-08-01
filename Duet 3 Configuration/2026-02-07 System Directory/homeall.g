echo "homeall"

M98 P"/sys/homex.g"                 ; call homex
M98 P"/sys/homey.g"                 ; call homey
M98 P"/sys/homez.g"                 ; call homez

if global.preprint_macro = false
    if sensors.probes[0].value[0] = 0
        M402            ;retract probe

    M98 P"/macros/purgepark.g"

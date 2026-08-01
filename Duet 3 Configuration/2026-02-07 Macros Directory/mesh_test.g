;M401
;M564 H0 S0
var original_x_min = move.axes[0].min
var original_x_max = move.axes[0].max
var original_y_min = move.axes[1].min
var original_y_max = move.axes[1].max
M208 X-163.8 S1           ;set axis minima
M208 X164.4 S0              ;set axis maxima
;M557 X-190:72 Y-160:0 P3:3
M557 X-134:134 Y-64.5:135.5 P10:10
;G1 X-134 Y-127 F6000
;M400
;echo "at -134, -127"
;G4 S1
G29 S0
echo "finished probing"
G4 S1
M400
echo "move to purge park"
G4 S1
M98 P"/macros/purgepark.g"
M400
;M564 H1 S1
echo "reset axis limits"
G4 S1
M208 X{var.original_x_min} Y{var.original_y_min} S1           ;set axis minima
M208 X{var.original_x_max} Y{var.original_y_max} S0              ;set axis maxima
echo "done"
;M402
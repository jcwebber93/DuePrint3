G90         ;absolute position
G1 X132 Y155 F18000
G1 X129.5 Y162 F6000
G1 X127 Y155 F6000
G1 X124.5 Y162 F6000
G1 X122 Y155 F6000
if job.build = null
	M98 P"/macros/purgepark.g"
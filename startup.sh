#!/bin/bash

EXTRA_ARGS=

if [ ! -z "$LAT" ] && [ ! -z "$LON" ]
then
	if [ -z "$ALT" ]
	then
		ALT=0
	fi
	EXTRA_ARGS="--home $LAT,$LON,$ALT,0"
fi

cat /ardupilot/Tools/autotest/default_params/copter.parm

/ardupilot/build/sitl/bin/arducopter -S -I0 --model + --speedup 1 --defaults /ardupilot/Tools/autotest/default_params/copter.parm ${EXTRA_ARGS}

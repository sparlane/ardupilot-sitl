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

cat /ardupilot/Tools/autotest/default_params/plane.parm

/ardupilot/build/sitl/bin/arduplane -S -I0 --model plane --speedup 1 --defaults /ardupilot/Tools/autotest/default_params/plane.parm ${EXTRA_ARGS}

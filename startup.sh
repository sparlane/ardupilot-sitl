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

cat /ardupilot/Tools/autotest/default_params/rover.parm

/ardupilot/build/sitl/bin/ardurover -S -I0 --model rover --speedup 1 --defaults /ardupilot/Tools/autotest/default_params/rover.parm ${EXTRA_ARGS}

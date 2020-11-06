#!/bin/bash

DEFAULTS=/ardupilot/Tools/autotest/default_params/sub.parm

EXTRA_ARGS=

if [ ! -z "$LAT" ] && [ ! -z "$LON" ]
then
	if [ -z "$ALT" ]
	then
		ALT=0
	fi
	EXTRA_ARGS="--home $LAT,$LON,$ALT,0"
fi

if [ ! -z "$ADSB" ]
then
    echo "ADSB_ENABLE	1" >> ${DEFAULTS}
fi

if [ ! -z "$BATT_CAPACITY" ]
then
	echo "BATT_CAPACITY	${BATT_CAPACITY}" >> ${DEFAULTS}
fi

cat $DEFAULTS

/ardupilot/build/sitl/bin/ardusub -S -I0 --model + --speedup 1 --defaults ${DEFAULTS} ${EXTRA_ARGS}

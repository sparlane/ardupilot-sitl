#!/bin/bash

TYPE=${VEHICLE_TYPE,,}

case $TYPE in
	copter)
		PARAMS=copter
		BIN=arducopter
		MODEL=+
		;;
	plane)
		PARAMS=plane
		BIN=arduplane
		MODEL=plane
		;;
	rover)
		PARAMS=rover
		BIN=ardurover
		MODEL=rover
		;;
	sub)
		PARAMS=sub
		BIN=ardusub
		MODEL=vectored
		;;
	*)
		echo "Unsupported type: $TYPE"
		exit -1
		;;
esac

DEFAULTS=/ardupilot/Tools/autotest/models/$PARAMS.parm
if [ ! -f "${DEFAULTS}" ]
then
	DEFAULTS=/ardupilot/Tools/autotest/default_parms/$PARAMS.parm
fi

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
    echo "ADSB_TYPE	1" >> ${DEFAULTS}
fi

if [ ! -z "$AVOIDANCE" ]
then
    echo "AVD_ENABLE	1" >> ${DEFAULTS}
    echo "AVD_F_ACTION	4" >> ${DEFAULTS}
    if [ ! -z "$AVOIDANCE_DIST" ]
    then
        AVOIDANCE_DIST=100
    fi
    echo "AVD_F_DIST_XY	${AVOIDANCE_DIST}" >> ${DEFAULTS}
    echo "AVD_F_RCVRY	1" >> ${DEFAULTS}
fi

if [ ! -z "$BATT_CAPACITY" ]
then
	echo "BATT_CAPACITY	${BATT_CAPACITY}" >> ${DEFAULTS}
fi

cat $DEFAULTS

/ardupilot/build/sitl/bin/$BIN -S -I0 --model $MODEL --speedup 1 --defaults ${DEFAULTS} ${EXTRA_ARGS}

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
	DEFAULTS=/ardupilot/Tools/autotest/default_params/$PARAMS.parm
fi

# Append one NAME<TAB>VALUE line to the defaults file the SITL binary is
# started with.  Later lines win, so anything set here overrides the
# firmware/model defaults above it.
set_param() {
	printf '%s\t%s\n' "$1" "$2" >> "${DEFAULTS}"
}

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
	set_param ADSB_ENABLE 1
	set_param ADSB_TYPE 1
fi

if [ ! -z "$AVOIDANCE" ]
then
	set_param AVD_ENABLE 1
	set_param AVD_F_ACTION 4
	if [ -z "$AVOIDANCE_DIST" ]
	then
		AVOIDANCE_DIST=100
	fi
	set_param AVD_F_DIST_XY "${AVOIDANCE_DIST}"
	set_param AVD_F_RCVRY 1
fi

if [ ! -z "$BATT_CAPACITY" ]
then
	set_param BATT_CAPACITY "${BATT_CAPACITY}"
fi

# Failsafe/GCS-identity parameters.  Each is optional and unset means "leave
# the firmware default alone".
#
# These exist so a simulated aircraft can be booted already configured the way
# a real airframe is expected to be, rather than being reconfigured in flight:
# some consumers (cap-fmu's advisory config check, for one) only look at the
# autopilot's config once, on the first heartbeat, so a parameter written after
# startup is a different test from a parameter the aircraft booted with.
#
#   SYSID_MYGCS     - which GCS system id the autopilot watches for heartbeats,
#                     i.e. whose disappearance triggers the GCS failsafe.
#   SYSID_ENFORCE   - whether traffic from any other system id is accepted.
#   FS_LONG_TIMEOUT - how long heartbeats can be absent before the long-failsafe
#                     action runs (Plane; Copter uses FS_GCS_TIMEOUT, which
#                     EXTRA_PARAMS below can set).
for param in SYSID_MYGCS SYSID_ENFORCE FS_LONG_TIMEOUT
do
	if [ ! -z "${!param}" ]
	then
		set_param "${param}" "${!param}"
	fi
done

# Escape hatch for everything not named above: EXTRA_PARAMS="NAME=VALUE ..."
# (whitespace and/or comma separated).  Applied last, so it can override any
# of the settings above.
#
# Named variables cover what this image is routinely asked for; EXTRA_PARAMS
# covers the rest without a new image release each time, which matters most
# for parameters that are vehicle-family dependent -- the GCS failsafe is
# FS_GCS_ENABL plus FS_LONG_ACTN on Plane but FS_GCS_ENABLE alone on Copter,
# so there is no single name worth promoting to a variable.
#
# Malformed entries are fatal rather than skipped: ArduPilot silently ignores
# a parameter name it does not recognise, so a typo would otherwise mean a
# vehicle that boots looking configured while flying the defaults.
if [ ! -z "$EXTRA_PARAMS" ]
then
	for assignment in ${EXTRA_PARAMS//,/ }
	do
		name=${assignment%%=*}
		value=${assignment#*=}
		if [[ "$assignment" != *=* ]] || [[ ! "$name" =~ ^[A-Z][A-Z0-9_]{0,15}$ ]]
		then
			echo "Invalid EXTRA_PARAMS entry: '${assignment}' (expected NAME=VALUE)"
			exit 1
		fi
		if [[ ! "$value" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
		then
			echo "Invalid EXTRA_PARAMS value for ${name}: '${value}' (expected a number)"
			exit 1
		fi
		set_param "${name}" "${value}"
	done
fi

cat $DEFAULTS

/ardupilot/build/sitl/bin/$BIN -S -I0 --model $MODEL --speedup 1 --defaults ${DEFAULTS} ${EXTRA_ARGS}

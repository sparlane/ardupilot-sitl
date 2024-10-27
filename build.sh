#!/bin/bash -ex

TYPE=$1

case $TYPE in
	Copter)
		TARGET=arducopter
		;;
	Plane)
		TARGET=arduplane
		;;
	Rover)
		TARGET=ardurover
		;;
	Sub)
		TARGET=ardusub
		;;
	*)
		echo "Unknown type $TYPE"
		exit -1
		;;
esac

/ardupilot/modules/waf/waf-light build --target bin/$TARGET

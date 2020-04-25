FROM sparlane/apm-build-source:copter-latest

WORKDIR /ardupilot

RUN ["/ardupilot/modules/waf/waf-light", "configure", "--board", "sitl"]

RUN ["/ardupilot/modules/waf/waf-light", "build", "--target", "bin/arducopter"]

WORKDIR /ardupilot/ArduCopter

ENTRYPOINT ["/ardupilot/build/sitl/bin/arducopter", "-S", "-I0", "--model", "+", "--speedup", "1", "--defaults", "/ardupilot/Tools/autotest/default_params/copter.parm"]

#ENTRYPOINT ["/ardupilot/Tools/autotest/sim_vehicle.py"]

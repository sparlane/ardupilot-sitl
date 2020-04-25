FROM sparlane/apm-build-source:plane-latest

WORKDIR /ardupilot

RUN ["/ardupilot/modules/waf/waf-light", "configure", "--board", "sitl"]

RUN ["/ardupilot/modules/waf/waf-light", "build", "--target", "bin/arduplane"]

WORKDIR /ardupilot/ArduPlane

ENTRYPOINT ["/ardupilot/build/sitl/bin/arduplane", "-S", "-I0", "--model", "plane", "--speedup", "1", "--defaults", "/ardupilot/Tools/autotest/default_params/plane.parm"]
#["/ardupilot/Tools/autotest/sim_vehicle.py"]

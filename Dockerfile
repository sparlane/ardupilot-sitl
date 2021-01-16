FROM sparlane/apm-build-source:plane-4.0.7

WORKDIR /ardupilot

RUN ["/ardupilot/modules/waf/waf-light", "configure", "--board", "sitl"]

RUN ["/ardupilot/modules/waf/waf-light", "build", "--target", "bin/arduplane"]

WORKDIR /ardupilot/ArduPlane
COPY startup.sh .

ENTRYPOINT ["/ardupilot/ArduPlane/startup.sh"]
#["/ardupilot/Tools/autotest/sim_vehicle.py"]

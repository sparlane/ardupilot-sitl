FROM sparlane/apm-build-source:copter-4.0.7

WORKDIR /ardupilot

RUN ["/ardupilot/modules/waf/waf-light", "configure", "--board", "sitl"]

RUN ["/ardupilot/modules/waf/waf-light", "build", "--target", "bin/arducopter"]

WORKDIR /ardupilot/ArduCopter
COPY startup.sh .

ENTRYPOINT ["/ardupilot/ArduCopter/startup.sh"]
#ENTRYPOINT ["/ardupilot/Tools/autotest/sim_vehicle.py"]

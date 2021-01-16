FROM sparlane/apm-build-source:sub-4.0.1

WORKDIR /ardupilot

RUN ["/ardupilot/modules/waf/waf-light", "configure", "--board", "sitl"]

RUN ["/ardupilot/modules/waf/waf-light", "build", "--target", "bin/ardusub"]

WORKDIR /ardupilot/ArduSub
COPY startup.sh .

ENTRYPOINT ["/ardupilot/ArduSub/startup.sh"]
#["/ardupilot/Tools/autotest/sim_vehicle.py"]

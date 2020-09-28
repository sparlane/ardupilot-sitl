FROM sparlane/apm-build-source:rover-latest

WORKDIR /ardupilot

RUN ["/ardupilot/modules/waf/waf-light", "configure", "--board", "sitl"]

RUN ["/ardupilot/modules/waf/waf-light", "build", "--target", "bin/ardurover"]

WORKDIR /ardupilot/APMrover2
COPY startup.sh .

ENTRYPOINT ["/ardupilot/APMrover2/startup.sh"]
#["/ardupilot/Tools/autotest/sim_vehicle.py"]

# VEHICLE_TYPE selects the build type to build (values: Plane,Copter,Sub,Rover)
ARG VEHICLE_TYPE=Plane
# ARDUPILOT_VERSION selects which version to build
ARG ARDUPILOT_VERSION

FROM sparlane/apm-build-source:${VEHICLE_TYPE}-${ARDUPILOT_VERSION}

# VEHICLE_TYPE selects the build type to build (values: Plane,Copter,Sub,Rover)
ARG VEHICLE_TYPE=Plane

WORKDIR /ardupilot

RUN ["/ardupilot/modules/waf/waf-light", "configure", "--board", "sitl"]

COPY build.sh .
RUN ./build.sh ${VEHICLE_TYPE}

WORKDIR /ardupilot/Ardu${VEHICLE_TYPE}
COPY startup.sh /

ENV VEHICLE_TYPE=${VEHICLE_TYPE}

ENTRYPOINT ["/startup.sh"]
#["/ardupilot/Tools/autotest/sim_vehicle.py"]

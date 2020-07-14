FROM ubuntu:18.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
            apt-get install -yq --no-install-recommends apt-utils \
            git nano ca-certificates cmake g++ gcc \
            lsb-release gnupg2 curl dos2unix && rm -rf /var/lib/apt/lists/*

COPY install_deps.sh /scripts/install_deps.sh


RUN cd /scripts/ && dos2unix install_deps.sh && bash install_deps.sh

CMD ["/bin/bash"]
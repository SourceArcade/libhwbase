FROM debian:trixie

RUN apt-get update && apt-get -y install wget git make gcc gnat && apt-get clean

ARG GNATPROVE_VERSION=11.2.0-3
ADD --unpack https://github.com/alire-project/GNAT-FSF-builds/releases/download/gnatprove-${GNATPROVE_VERSION}/gnatprove-x86_64-linux-${GNATPROVE_VERSION}.tar.gz /opt
ENV PATH=/opt/gnatprove-x86_64-linux-${GNATPROVE_VERSION}/bin:${PATH}

RUN useradd -p locked -m gnatbot
USER gnatbot
WORKDIR /home/gnatbot

RUN git clone https://review.sourcearcade.org/libhwbase.git
RUN git clone https://review.sourcearcade.org/libgfxinit.git

RUN cd libhwbase && git fetch origin refs/changes/75/475/1 && git rebase FETCH_HEAD
RUN cd libhwbase && make -j$(nproc) cnf=configs/linux install

COPY ci.sh /
ENTRYPOINT ["/bin/sh", "/ci.sh"]

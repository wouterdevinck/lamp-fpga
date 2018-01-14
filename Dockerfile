FROM ubuntu:17.10

COPY installtools.sh .

RUN apt-get update && \
    apt-get -y install sudo && \
    useradd -m docker && echo "docker:docker" | chpasswd && \
    adduser docker sudo && \
    echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER docker

RUN sudo apt-get update && \
    sudo apt-get install -y \
      apt-utils pkg-config \
      git mercurial \
      build-essential clang \
      libffi-dev libftdi-dev \
      graphviz xdot gperf \
      gawk tclsh tcl-dev \
      libreadline-dev bison \
      flex python autoconf

RUN ./installtools.sh
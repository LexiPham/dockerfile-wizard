FROM lexipham/node-java-emulator:1

LABEL maintainer "phamkoko@gmail"

WORKDIR /

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y virtinst cpu-checker
RUN kvm-ok
# openjdk-8-jdk nodejs vim git unzip libglu1 libpulse-dev libasound2 
# libc6 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 
# libxi6  libxtst6 libnss3 wget qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

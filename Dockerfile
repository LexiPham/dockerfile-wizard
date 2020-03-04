FROM ubuntu:18.04

LABEL maintainer "phamkoko@gmail"

WORKDIR /

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y openjdk-8-jdk vim git unzip libglu1 libpulse-dev libasound2 libc6 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

#=====================
# Install Android SDK
#=====================

ARG ANDROID_API_LEVEL=28
ARG ANDROID_BUILD_TOOLS_LEVEL=28.0.3
ARG EMULATOR_NAME='test'

RUN wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip' -P /tmp \
&& unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip \
&& yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-${ANDROID_API_LEVEL};google_apis;x86" "platforms;android-${ANDROID_API_LEVEL}" "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" "emulator" \
&& yes Y | /opt/android/tools/bin/sdkmanager --licenses \
&& echo "no" | /opt/android/tools/bin/avdmanager --verbose create avd --force --name "test" --device "pixel" --package "system-images;android-${ANDROID_API_LEVEL};google_apis;x86" --tag "google_apis" --abi "x86"

ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

#====================================
# Install latest nodejs, npm, appium
# Using this workaround to install Appium -> https://github.com/appium/appium/issues/10020 -> Please remove this workaround asap
#====================================
ARG APPIUM_VERSION=1.7.0-beta
ENV APPIUM_VERSION=$APPIUM_VERSION

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash && \
    apt-get -qqy install nodejs && \
    npm install -g appium@${APPIUM_VERSION} --unsafe-perm=true --allow-root && \
    exit 0 && \
    npm cache clean && \
    apt-get remove --purge -y npm && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean

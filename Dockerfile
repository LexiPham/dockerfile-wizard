FROM ubuntu

LABEL maintainer "phamkoko@gmail"

WORKDIR /

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y openjdk-8-jdk nodejs vim git unzip libglu1 libpulse-dev libasound2 libc6 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxi6  libxtst6 libnss3 wget qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils

#=====================
# Install Android SDK
#=====================
ARG ANDROID_API_LEVEL=25
ARG ANDROID_BUILD_TOOLS_LEVEL=25.0.3
ARG EMULATOR_NAME='test'

RUN wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip' -P /tmp \
&& unzip -d /opt/android /tmp/sdk-tools-linux-4333796.zip \
&& yes Y | /opt/android/tools/bin/sdkmanager --install "platform-tools" "system-images;android-${ANDROID_API_LEVEL};google_apis;x86" "platforms;android-${ANDROID_API_LEVEL}" "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" "emulator" \
&& yes Y | /opt/android/tools/bin/sdkmanager --licenses \
&& echo "no" | /opt/android/tools/bin/avdmanager --verbose create avd --force --name "test" --device "pixel" --package "system-images;android-${ANDROID_API_LEVEL};google_apis;x86" --tag "google_apis" --abi "x86" 

#=====================
# Add android tools and platform tools to PATH
#=====================
ENV ANDROID_HOME=/opt/android
ENV PATH "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

FROM openjdk:8-jdk-slim@sha256:c6a0df0ff6377656c2b35617e415e278257c87dc753789b1b5acef6dd77f4049
LABEL maintainer "Oanh Pham <phamkoko@gmail.com>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

# hadolint ignore=DL3009
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
  curl \
  gnupg2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
  nodejs \
  yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
  
# RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
# RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
# RUN apt-get -y update
# RUN apt-get -y install google-chrome-stable

# Install another dependencies
RUN apt-get update && apt-get install gnupg2 git wget unzip gcc-multilib libglu1 -y

#Install Android
ENV ANDROID_HOME /opt/android
RUN wget -O android-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip --show-progress \
&& unzip android-tools.zip -d $ANDROID_HOME && rm android-tools.zip
ENV PATH $PATH:$ANDROID_HOME/tools/bin

RUN pwd
RUN mkdir -p .android && touch ~/.android/repositories.cfg

#Install Android Tools
RUN yes | sdkmanager --update --verbose
RUN yes | sdkmanager "platform-tools" --verbose
RUN yes | sdkmanager "platforms;android-27" --verbose
RUN yes | sdkmanager "build-tools;27.0.0" --verbose
RUN yes | sdkmanager "build-tools;28.0.3" --verbose
RUN yes | sdkmanager "extras;android;m2repository" --verbose
RUN yes | sdkmanager "extras;google;m2repository" --verbose

# Add platform-tools and emulator to path
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_HOME/emulator

#Install latest android emulator system images
ENV EMULATOR_IMAGE "system-images;android-24;google_apis;x86_64"
RUN yes | sdkmanager $EMULATOR_IMAGE --verbose

# Copy Qt library files to system folder
RUN cp -a /opt/android/emulator/lib64/qt/lib/. /usr/lib/x86_64-linux-gnu/

# Creating a emulator with sdcard
RUN echo "no" | avdmanager -v create avd -n test -k $EMULATOR_IMAGE -c 100M

ADD start_emulator.sh /bin/start_emulator
RUN chmod +x /bin/start_emulator

ADD wait_emulator_boot.sh /bin/wait_emulator
RUN chmod +x /bin/wait_emulator

ADD unlock_emulator.sh /bin/unlock_emulator
RUN chmod +x /bin/unlock_emulator

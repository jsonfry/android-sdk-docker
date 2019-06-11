FROM openjdk:8-slim
MAINTAINER jsonfry "jason@ocasta.com"

# Install Java
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y curl unzip \
    && apt-get clean

# Download And Extract Android SDK
WORKDIR /opt/android-sdk
RUN curl -o tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && unzip tools.zip \
    && rm -f tools.zip

# Android SDK Paths
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN mkdir -p ${ANDROID_HOME}/licenses
RUN echo 24333f8a63b6825ea9c5514f83c2829b004d1fee > ${ANDROID_HOME}/licenses/android-sdk-license

# Android packages
ADD packages /opt/android-sdk/packages
RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg
# RUN sdkmanager --package_file=packages
# Workaround https://issuetracker.google.com/issues/66465833
RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < packages && sdkmanager ${PACKAGES}

# ADB Key - Be careful what you do with devices that trust the built in key
ADD adbkey /root/.android/adbkey
ADD adbkey.pub /root/.android/adbkey.pub

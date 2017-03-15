FROM ubuntu:14.04
MAINTAINER jsonfry "jason@ocasta.com"

# Install Java
RUN DEBIAN_FRONTEND=noninteractive \
    && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install -y --no-install-recommends oracle-java8-installer lib32ncurses5 lib32stdc++6 lib32z1 unzip \
    && apt-get clean

# Download And Extract Android SDK
WORKDIR /opt/android-sdk
RUN wget -nv http://dl.google.com/android/repository/tools_r25.2.5-linux.zip \
    && unzip tools_r25.2.5-linux.zip \
    && rm -f tools_r25.2.5-linux.zip

# Android SDK Paths
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN mkdir -p ${ANDROID_HOME}/licenses
RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > ${ANDROID_HOME}/licenses/android-sdk-license

# Platform tools
ADD packages /opt/android-sdk/packages
RUN sdkmanager --package_file=packages
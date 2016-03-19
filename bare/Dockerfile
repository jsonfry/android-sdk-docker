FROM ubuntu:14.04
MAINTAINER jsonfry "jason@ocasta.co"

# Install Java7
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
    && apt-get update \
    && echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install -y --no-install-recommends oracle-java7-installer \
    && apt-get clean

# Download And Extract Android SDK
WORKDIR /opt
RUN wget -nv http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
    && tar xzf android-sdk_r24.4.1-linux.tgz \
    && rm -f android-sdk_r24.4.1-linux.tgz \
    && chmod -R +xr /opt/android-sdk-linux


# Android SDK Paths
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN echo y | android update sdk --no-ui --all --filter tools,platform-tools

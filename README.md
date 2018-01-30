[![](https://images.microbadger.com/badges/image/jsonfry/android-sdk.svg)](https://microbadger.com/images/jsonfry/android-sdk)

# Android Docker Images For CI

Includes the last three versions of SDK and some commonly used packages. See the `packages` file for a full list. (Generally) Built once per month to ensure up to date versions of non versioned SDK componenets.

Example Usage with Drone:

```
pipeline:
  restore-cache:
    image: drillster/drone-volume-cache
    restore: true
    mount:
      - ./app/build
      - ./build
      - ./.gradle
    volumes:
      - /tmp/cache:/cache

  test:
    image: jsonfry/android-sdk:18.01
    pull: true
    commands:
      - export GRADLE_USER_HOME=$PWD/.gradle # so we can cache dependencies
      - ./gradlew clean check
    when:
      event: push

  fabricbeta:
    image: jsonfry/android-sdk:18.01
    pull: true
    secrets: [ app_key ] # if you pass in your app's key as an environment variable
    commands:
      - export GRADLE_USER_HOME=$PWD/.gradle
      - ./gradlew assembleRelease crashlyticsUploadDistributionRelease
  when:
    branch: develop
    event: push

  testdevices:
    image: jsonfry/android-sdk:18.01
    pull: true
    devices:
      - "/dev/bus/usb:/dev/bus/usb"
    commands:
      - export GRADLE_USER_HOME=$PWD/.gradle
      - adb devices # useful when things aren't working...
      - ./gradlew clean connectedAndroidTest
    when:
      branch: develop
      event: push

  release:
    image: jsonfry/android-sdk:18.01
    pull: true
    secrets: [ app_key ]
    commands:
      - export GRADLE_USER_HOME=$PWD/.gradle
      - ./gradlew clean assembleRelease
    when:
      event: tag

  rebuild-cache:
    image: drillster/drone-volume-cache
    rebuild: true
    mount:
      - ./app/build
      - ./build
      - ./.gradle
    volumes:
      - /tmp/cache:/cache

```


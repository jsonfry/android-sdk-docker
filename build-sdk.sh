#!/bin/bash
# As described by `android list sdk --all --extended`

sdks=( "23" "22" "21" "20" "19" "18" "17" "16" "15" )
build_tools=( "23.0.3" )
dockerfile_base=$'FROM jsonfry/android-sdk:support\n'

for sdk in "${sdks[@]}"
do
    for build_tool in "${build_tools[@]}"
    do
        dockerfile_runs="RUN echo y | android update sdk --no-ui --all --filter android-$sdk"
        dockerfile_runs+=$'\n'
        dockerfile_runs+="RUN echo y | android update sdk --no-ui --all --filter build-tools-$build_tool"
        echo "$dockerfile_base $dockerfile_runs" | docker build -t jsonfry/android-sdk:$sdk-$build_tool -
        docker push jsonfry/android-sdk:$sdk-$build_tool

        dockerfile_runs+=$'\n'
        dockerfile_runs+="RUN echo y | android update sdk --no-ui --all --filter addon-google_apis-google-$sdk"
        echo "$dockerfile_base $dockerfile_runs" | docker build -t jsonfry/android-sdk:$sdk-$build_tool-g -
        docker push jsonfry/android-sdk:$sdk-$build_tool-g
    done
done

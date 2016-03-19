# As described by `android list sdk --all --extended`

sdks=( "23" "22" "21" "20" "19" "18" "17" "16" "15" )
build_tools=( "23.0.2" "23.0.1" "22.0.1" "21.1.2" "20.0.0" "19.1.0" )
dockerfile_base=$'FROM jsonfry/android-sdk:support\n'

for sdk in "${sdks[@]}"
do
    for build_tool in "${build_tools[@]}"
    do
        dockerfile="RUN echo y | android update sdk --no-ui --all --filter android-$sdk,build-tools-$build_tool"
        dockerfile+=$'\n'
        dockerfile+="RUN echo y | android update sdk --no-ui --all --filter addon-google_apis-google-$sdk"
        echo "$dockerfile_base $dockerfile" | docker build -t jsonfry/android-sdk:$sdk-$build_tool -
        docker push jsonfry/android-sdk:$sdk-$build_tool
    done
done

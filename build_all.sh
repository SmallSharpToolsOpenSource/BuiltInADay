#!/bin/sh

pod install --no-integrate

# fetching a list of the project names from the Podfile would be helpful here

./build_universal.sh Alamofire
./build_universal.sh AFNetworking
./build_universal.sh FormatterKit

BLUE_COLOR='\033[0;34m'
NO_COLOR='\033[0m'
echo "${BLUE_COLOR}Done${NO_COLOR}"

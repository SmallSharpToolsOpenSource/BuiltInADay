#!/bin/sh

GREEN_COLOR="\033[0;32m"
BLUE_COLOR='\033[0;34m'
NO_COLOR='\033[0m'

pod install --no-integrate

PODS=`cat Podfile | grep "^[\t ]*pod" | sed s/"^[\t ]*pod ['\"]"// | sed s/"['\"].*$"// | uniq`

for p in $PODS
do
  echo "${BLUE_COLOR}=== Building ===${p}${NO_COLOR}"
  ./build_universal.sh "${p}"
done

echo "${BLUE_COLOR}Done${NO_COLOR}"

#!/bin/sh

# require 1 argument
if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` <project name>"
  exit $E_BADARGS
fi

PROJECT_NAME=$1

test -n "$XCODEBUILD"   || XCODEBUILD=$(which xcodebuild)
test -n "$LIPO"         || LIPO=$(which lipo)

test -x "$XCODEBUILD" || die 'Could not find xcodebuild in $PATH'
test -x "$LIPO" || die 'Could not find lipo in $PATH'

if [ ! -d "Pods" ]; then
  echo "Please run the following command and try again."
  GREEN_COLOR='\033[0;32m'
  NO_COLOR='\033[0m'
  echo "${GREEN_COLOR}pod install --no-integrate${NO_COLOR}"
  exit
fi

POD_DIR="Pods/${PROJECT_NAME}"

if [ ! -d "${POD_DIR}" ]; then
  echo "Pod directory not found: ${POD_DIR}"
  exit
fi

UNIVERSAL_OUTPUTFOLDER=../build
BUILD_DIR=$UNIVERSAL_OUTPUTFOLDER
BUILD_ROOT=$UNIVERSAL_OUTPUTFOLDER
CONFIGURATION=Release

TARGET_NAME=Pods-${PROJECT_NAME}
FRAMEWORK_DIR=${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework

# Use lipo to combine arch binaries into a universal binary

if [ -d Pods ]; then
  cd Pods/

  # Step 1. Build simulator and device versions
  $XCODEBUILD -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
  $XCODEBUILD -target "${TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

  # Step 2. Copy the framework structure to the universal folder
  cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/Pods/${PROJECT_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

  SIMULATOR_BINARY="${UNIVERSAL_OUTPUTFOLDER}/${CONFIGURATION}-iphonesimulator/Pods/${PROJECT_NAME}.framework/${PROJECT_NAME}"
  IPHONE_BINARY="${UNIVERSAL_OUTPUTFOLDER}/${CONFIGURATION}-iphoneos/Pods/${PROJECT_NAME}.framework/${PROJECT_NAME}"
  UNIVERSAL_BINARY=${FRAMEWORK_DIR}/${PROJECT_NAME}
  
  mkdir -p "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework"

  # Step 3. Create universal binary file using lipo and place the combined executable in the copied framework directory
  $LIPO -create -output "${UNIVERSAL_BINARY}" "${SIMULATOR_BINARY}"  "${IPHONE_BINARY}"
  $LIPO -info "${UNIVERSAL_BINARY}"
  
  mkdir -p ../Rome
  cp -rp ${FRAMEWORK_DIR} ../Rome
fi

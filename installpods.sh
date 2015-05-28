#!/bin/sh

rm Podfile.lock 
rm -rf Pods/

pod install --no-integrate


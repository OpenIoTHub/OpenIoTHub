#!/usr/bin/env bash
wget -q https://dl.google.com/android/repository/android-ndk-r21-linux-x86_64.zip
sudo unzip android-ndk-r21-linux-x86_64.zip -d $ANDROID_HOME/ndk
mv $ANDROID_HOME/ndk/android-ndk-r21 $ANDROID_HOME/ndk/21.0.6113669
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/21.0.6113669


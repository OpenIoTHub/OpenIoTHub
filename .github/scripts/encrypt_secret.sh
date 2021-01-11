#!/bin/sh

gpg --symmetric --cipher-algo AES256 ./android/key.jks
gpg --symmetric --cipher-algo AES256 ./android/key.properties
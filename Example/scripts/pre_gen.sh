#!/bin/sh

# find xcodeproj name and remove it
xcodeproj=$(find . -maxdepth 1 -type d -name "*.xcodeproj" -print | head -1)
rm -rf $xcodeproj
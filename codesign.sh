#!/bin/bash

DEVELOPER_ID_APP=$1
BUNDLE_ID=$2
export "DEVELOPER_ID_APP=$DEVELOPER_ID_APP"
export "BUNDLE_ID=$BUNDLE_ID"

signFile() {
  filename=$1

  if [ -f "$filename" ]; then
    echo "Signing FILE: $filename"
    codesign --deep -s "$DEVELOPER_ID_APP" -v -f --timestamp -i "$BUNDLE_ID" -o runtime "$filename"
    codesign -vvv --deep --strict "$filename"
  else
    echo "Skipping directory: $filename"
  fi
}

export -f signFile
find .build/release -exec bash -c 'signFile "{}"' \;
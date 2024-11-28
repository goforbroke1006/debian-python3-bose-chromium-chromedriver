#!/usr/bin/env bash

# https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json
versions=(
'114.0.5735.133'
'115.0.5790.102'
'116.0.5845.96'
'117.0.5938.149'
'118.0.5993.54'
'119.0.6045.105'
'120.0.6099.109'
)

mkdir -p ./chrome

for ver in "${versions[@]}"; do
  if [ ! -f "chrome/${ver}/chrome-linux64.zip" ]; then
    mkdir -p "chrome/${ver}/"
    curl -L https://storage.googleapis.com/chrome-for-testing-public/"${ver}"/linux64/chrome-linux64.zip -o "chrome/${ver}/chrome-linux64.zip"
  fi
done

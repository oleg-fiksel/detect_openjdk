#!/bin/sh
echo "$0: Inverting return code on exit"
$1
if [[ -z $? ]]; then
  exit 1
else
  exit 0
fi

#!/bin/sh

$1
if [[ -z $? ]]; then
  exit 1
else
  exit 0
fi

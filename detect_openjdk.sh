#!/bin/sh

# This scrips searches for any executable named java on the filesystem
# and runs it with -version parameter
# the output is validated if it's matching the substring of "OpenJDK"
# This can be used to run in the CI pipeline to check if OpenJDK is used in a Docker image
#
# Return codes:
# 1 - at least one executable found that is named "java" and has no "OpenJDK" in it's output when run with argument "-version"
# 0 - otherwise

oracle_jdk_detected=0
for i in $(find / -name java -perm /o=x \( -type f -or -type l \)); do
  echo -n "Checking $i ..."
  java_version_output=$($i -version 2>&1)
  echo -n "$java_version_output" | grep -qi OpenJDK
  retcode=$?
  if [[ "$retcode" == 0 ]]; then
    echo -e '\e[1;32mok\e[0m'
    echo -en '\e[1;30m'
    echo "$java_version_output"
    echo -en '\e[0m'
  else
    echo -e '\e[1;31mnot ok\e[0m'
    echo -en '\e[1;30m'
    echo "$java_version_output"
    echo -en '\e[0m'
    oracle_jdk_detected=1
  fi
done

exit ${oracle_jdk_detected}

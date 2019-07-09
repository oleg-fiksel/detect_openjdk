#!/bin/sh

VERSION=1.0.0

echo "---==( $0 Version ${VERSION} )==---"

: <<'EOF'
#@{start}
# Description

This scrips searches for any executable named java on the filesystem
and runs it with -version parameter
the output is validated if it's matching the substring of "OpenJDK"
This can be used to run in the CI pipeline to check if OpenJDK is used in a Docker image

# Return codes
* 1 - at least one executable found that is named "java" and has no "OpenJDK" in it's output when run with argument "-version"
* 0 - otherwise

# Dependencies

All dependencies are present in the [busybox](https://hub.docker.com/_/busybox) Docker image.

* `sh`
* gnu `find`
* gnu `grep`
* `echo`
#@{end}
EOF

#@{start}
# Main function
#@{inline}```bash
# Return 0 also if no java is found
non_openjdk_detected=0
# Find all java files, which are executable and not symlinks
# Known bug: -perm /o=x doesn't work in Mac OS X
for i in $(find / -name java -perm /o=x \( -type f -or -type l \)); do
  echo -n "Checking $i ..."
  # Run java -version and record output in a variable
  java_version_output=$($i -version 2>&1)
  # Search in the java -version output for OpenJDK
  # and record the return code
  echo -n "$java_version_output" | grep -qi OpenJDK
  retcode=$?
  if [[ "$retcode" == 0 ]]; then
    # OpenJDK found
    echo -e '\e[1;32mok\e[0m'
    echo -en '\e[1;30m'
    echo "$java_version_output"
    echo -en '\e[0m'
  else
    # non-OpenJDK found
    echo -e '\e[1;31mnot ok\e[0m'
    echo -en '\e[1;30m'
    echo "$java_version_output"
    echo -en '\e[0m'
    non_openjdk_detected=1
  fi
done

exit ${non_openjdk_detected}
#@{inline}```
#@{end}

#!/bin/bash

NAME=${NAME:-"cooker"}
ARCH=${ARCH:-"x86_64"}
BRANCH=${BRANCH:-"v0.6.1-abf-worker-service"}

script_path=`pwd`

NAME=${NAME} BRANCH=${BRANCH} ARCH=${ARCH} /bin/bash ${script_path}/${TYPE}.sh
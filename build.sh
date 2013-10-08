#!/bin/bash

PRODUCTNAME=${PRODUCTNAME:-"vagrant-box"}
ARCH=${ARCH:-"x86_64"}
product_type="$PRODUCT_TYPE"

BRANCH=${BRANCH:-"v0.6.1-abf-worker-service"}

script_path=`pwd`

PRODUCTNAME=$PRODUCTNAME BRANCH=$BRANCH ARCH=$ARCH /bin/bash "$script_path/$product_type.sh"
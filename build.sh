#!/bin/bash

PRODUCTNAME=${PRODUCTNAME:-"vagrant-box"}
product_type="$PRODUCT_TYPE"

BRANCH=${BRANCH:-"v0.6.1-abf-worker-service"}

script_path=`pwd`

PRODUCTNAME=$PRODUCTNAME BRANCH=$BRANCH /bin/bash "$script_path/$product_type.sh"
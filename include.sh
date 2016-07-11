#!/bin/bash

set -e

info() {
    DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
    echo $(basename $DIR): $1;
}

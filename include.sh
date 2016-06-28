#!/bin/bash

set -e

function echo() {
    DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
    builtin echo $(basename $DIR): $1;
}

#!/bin/bash -e
echo "Running Blin with parameters: $@"
cp -r /Blin/* /mnt
cd /mnt

if [ -z "$@" ]; then
    export TEST_LATEST=1
    raku -Iinst#/opt/rakudo-pkg/var/zef -I. bin/blin.p6
else
    raku -Iinst#/opt/rakudo-pkg/var/zef -I. bin/blin.p6 $@
fi

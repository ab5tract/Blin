#!/bin/bash -e
echo "Running Blin with parameters: $@"
cp -r /Blin/* /mnt
cd /mnt
#raku -Iinst#/opt/rakudo-pkg/var/zef  bin/blin.p6 $@
/bin/bash

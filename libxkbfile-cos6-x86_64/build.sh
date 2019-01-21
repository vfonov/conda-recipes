#!/bin/bash

for RPM in $(find ${PWD}/binary -name "*.rpm.dummy");do
echo RPM=$RPM
mkdir -p ${PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot
pushd ${PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot > /dev/null 2>&1
  "${RECIPE_DIR}"/rpm2cpio "${RPM}" | cpio -idmv
  popd > /dev/null 2>&1
done


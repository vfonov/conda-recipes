#!/bin/bash

export UDUNITS2_INCLUDE=${CONDA_PREFIX}/include
export UDUNITS2_LIBS=${CONDA_PREFIX}/lib

mv DESCRIPTION DESCRIPTION.old
grep -v '^Priority: ' DESCRIPTION.old > DESCRIPTION
$R CMD INSTALL --build .

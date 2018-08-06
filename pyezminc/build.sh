#! /bin/bash
set -e -x

python setup.py build && python setup.py install

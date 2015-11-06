#!/bin/bash

for x in input/*.cia; do . tools/process.sh $x input/hs.app; done

#!/bin/bash

if [ -e input/hs.app ]
then for x in input/*.cia; do . tools/process.sh $x input/hs.app; done
else printf "ERROR: hs.app not found\nPlease generate hs.app with Decrypt9 and put it into the input folder\n"
fi

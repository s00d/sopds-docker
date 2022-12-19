#!/bin/bash

rm sopds-pv-current.zip
cd opt && zip -r -X "../sopds-pv-current.zip" . && cd ..

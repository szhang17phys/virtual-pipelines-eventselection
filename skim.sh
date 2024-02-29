#!/bin/bash

INPUT_DIR=$1
OUTPUT_DIR=$2

# Sanitize input path, XRootD breaks if we double accidentally a slash
if [ "${INPUT_DIR: -1}" = "/" ];
then
    INPUT_DIR=${INPUT_DIR::-1}
fi

# Compile executable
echo ">>> Compile skimming executable ..."
COMPILER=$(root-config --cxx)
FLAGS=$(root-config --cflags --libs)
time $COMPILER -g -O3 -Wall -Wextra -Wpedantic -o skim skim.cxx $FLAGS

# Skim samples
while IFS=, read -r SAMPLE XSEC
do
    echo ">>> Skim sample ${SAMPLE}"
    INPUT=${INPUT_DIR}/${SAMPLE}.root
    OUTPUT=${OUTPUT_DIR}/${SAMPLE}Skim.root
    LUMI=11467.0 # Integrated luminosity of the unscaled dataset
    SCALE=0.1 # Same fraction as used to down-size the analysis
    ./skim $INPUT $OUTPUT $XSEC $LUMI $SCALE
done < skim.csv

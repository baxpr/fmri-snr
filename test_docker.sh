#!/usr/bin/env bash

docker run \
    --mount type=bind,src=`pwd -P`/INPUTS,dst=/INPUTS \
    --mount type=bind,src=`pwd -P`/OUTPUTS,dst=/OUTPUTS \
    fmri-snr:test \
    --meanfmri_niigz /INPUTS/wmeanadfmri.nii.gz \
    --gm_niigz /INPUTS/wp1t1.nii.gz \
    --out_dir /OUTPUTS

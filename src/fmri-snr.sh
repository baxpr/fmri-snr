#!/usr/bin/env bash

# Initialize defaults for any input parameters where that seems useful
export roi_dir=/opt/fmri-snr/rois
export roi_img=Schaefer2018_400Parcels_7Networks_order_FSLMNI152_2mm.nii.gz
export roi_csv=
export out_dir=/OUTPUTS

# Parse input options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --meanfmri_niigz) export meanfmri_niigz="$2"; shift; shift ;;
        --roi_img)        export roi_img="$2";        shift; shift ;;
        --roi_csv)        export roi_csv="$2";        shift; shift ;;
        --gm_niigz)       export gm_niigz="$2";       shift; shift ;;
        --out_dir)        export out_dir="$2";        shift; shift ;;
        --roi_dir)        export roi_dir="$2";        shift; shift ;;
        *) echo "Input ${1} not recognized"; shift ;;
    esac
done

# Work in out_dir
cd "${out_dir}"

# Copy input images
cp "${meanfmri_niigz}" meanfmri.nii.gz
cp "${gm_niigz}" gm.nii.gz

# If external ROI image is supplied (i.e. $roi_img includes a path), copy it,
# else find the internal ROI image and label
if [[ $(basename "${roi_img}") != "${roi_img}" ]]; then
    if [[ -z "${roi_csv}" ]]; then
        echo "No ROI label CSV supplied"
        exit 1
    fi
    cp "${roi_img}" origroi.nii.gz
    cp "${roi_csv}" roi-labels.csv
else
    thisroi_img=$(find "${roi_dir}" -name "${roi_img}")
    if [[ -z "${thisroi_img}" ]]; then
        echo "Failed to find ${roi_img} in ${roi_dir}"
        exit 1
    fi
    thisroi_csv=$(dirname "${thisroi_img}")/$(basename "${thisroi_img}" .nii.gz)-labels.csv
    cp "${thisroi_img}" origroi.nii.gz
    cp "${thisroi_csv}" roi-labels.csv
fi

# Create brain mask and resample to fmri geometry
fslmaths gm -thr 0.9 -bin origmask
flirt -usesqform -applyxfm -interp nearestneighbour \
    -in origmask \
    -ref meanfmri \
    -out mask

# Resample ROI image to fmri geometry
flirt -usesqform -applyxfm -interp nearestneighbour \
    -in origroi \
    -ref meanfmri \
    -out roi

# Median value in fMRI within mask
maskmedian=$(fslstats meanfmri -k mask -p 50)

# Mean ROI signal extraction, mean and time series
echo Extracting ROI signals
fslmeants -i meanfmri -o meanroidata.txt --label=roi

# Compute regional stats
roi_to_csv.py roi-labels.csv meanroidata.txt "${maskmedian}" "${out_dir}"


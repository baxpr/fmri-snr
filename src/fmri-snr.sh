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
        --fmri_niigz)     export fmri_niigz="$2";     shift; shift ;;
        --roi_img)        export roi_img="$2";        shift; shift ;;
        --roi_csv)        export roi_csv="$2";        shift; shift ;;
        --gm_niigz)       export gm_niigz="$2";     shift; shift ;;
        --t1_niigz)       export t1_niigz="$2";     shift; shift ;;
        --out_dir)        export out_dir="$2";        shift; shift ;;
        --roi_dir)        export roi_dir="$2";        shift; shift ;;
        *) echo "Input ${1} not recognized"; shift ;;
    esac
done

# Copy input images
cp "${fmri_niigz}" "${out_dir}"/fmri.nii.gz
cp "${gm_niigz}" "${out_dir}"/gm.nii.gz
cp "${t1_niigz}" "${out_dir}"/t1.nii.gz

# If external ROI image is supplied (i.e. $roi_img includes a path), copy it,
# else find the internal ROI image and label
if [[ $(basename "${roi_img}") != "${roi_img}" ]]; then
    if [[ -z "${roi_csv}" ]]; then
        echo "No ROI label CSV supplied"
        exit 1
    fi
    cp "${roi_img}" "${out_dir}"/origroi.nii.gz
    cp "${roi_csv}" "${out_dir}"/roi-labels.csv
else
    thisroi_img=$(find "${roi_dir}" -name "${roi_img}")
    if [[ -z "${thisroi_img}" ]]; then
        echo "Failed to find ${roi_img} in ${roi_dir}"
        exit 1
    fi
    thisroi_csv=$(basename "${thisroi_img}" .nii.gz)-labels.csv
    cp "${thisroi_img}" "${out_dir}"/origroi.nii.gz
    cp "${thisroi_csv}" "${out_dir}"/roi-labels.csv
fi

# Resample ROI image to fmri geometry
flirt -usesqform -applyxfm -interp nearestneighbour \
    -in "${out_dir}"/origroi \
    -ref "${out_dir}"/fmri \
    -out "${out_dir}"/roi

# FIXME we are here

# ROI time series extraction
roi_extract.sh

# Unzip image files for SPM
gunzip "${out_dir}"/*.nii.gz
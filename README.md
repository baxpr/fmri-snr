# fMRI SNR

## Inputs

All must be aligned in the same space (e.g. native or MNI) but needn't be on the same voxel grid.

- Gray matter mask from a structural segmentation
- White matter mask from a structural segmentation
- ROI image (or filename of an MNI space image internal to the container)
- CSV of ROI region labels if ROI image is supplied. Needs columns Region for ROI name, and Label for integer index
- Mean fmri image
- fMRI time series image


## Outputs

- fractional_intensity: Mean signal in ROI divided by median intensity of gray+white matter in mean fMRI
- snr: Mean ROI signal divided by standard deviation of mean ROI time series
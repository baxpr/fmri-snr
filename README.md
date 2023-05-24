# fMRI SNR

## Inputs

All must be aligned in the same space (e.g. native or MNI) but needn't be on the same voxel grid.

- Bias field corrected T1 image
- Gray matter mask from a structural segmentation
- ROI image (or filename of an MNI space image internal to the container)
- CSV of ROI region labels if ROI image is supplied. Needs columns Region for ROI name, and Label for integer index
- fMRI time series


## Outputs

- Fractional intensity from mean fMRI: mean signal in ROI divided by 10% trimmed mean of gray matter (Could use mean of in-brain voxels (via spm_antimode) as denominator instead of trimmed mean)
- SNR: Mean signal in ROI divided by standard deviation of global gray matter signal
- Something relative to T1? E.g. ratio of fractional intensities

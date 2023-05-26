#!/usr/bin/env python
#
# Read FSL .txt timeseries and convert to csv

import pandas
import sys

roicsv = sys.argv[1]
meanfsltxt = sys.argv[2]
fsltxt = sys.argv[3]
denom = sys.argv[4]

# Output filename
meanfslcsv = meanfsltxt.replace('.txt', '.csv')
fslcsv = fsltxt.replace('.txt', '.csv')

# Read ROI labels
roiinfo = pandas.read_csv(roicsv)

# Read time series into data frame and add labels
meandata = pandas.read_csv(
    meanfsltxt, 
    delim_whitespace=True, 
    usecols=roiinfo.Label-1,
    names=roiinfo.Region,
    dtype=float,
    )
data = pandas.read_csv(
    fsltxt, 
    delim_whitespace=True, 
    usecols=roiinfo.Label-1,
    names=roiinfo.Region,
    dtype=float,
    )
    
# Rescale by whole brain mean
meandata = meandata.applymap(lambda x: x/float(denom))
data = data.applymap(lambda x: x/float(denom))

# Transpose
region = list(meandata.columns)
fracint = list(meandata.iloc[0,:].values)
result = pandas.DataFrame(zip(region, fracint), columns=['region','fractional_intensity'])

# Write to csv
result.to_csv(fslcsv, index=False)

#!/usr/bin/env python3
#
# Read FSL .txt timeseries and convert to csv

import numpy
import pandas
import sys

roicsv = sys.argv[1]
meanfsltxt = sys.argv[2]
denom = sys.argv[3]

# Output filename
meanfslcsv = meanfsltxt.replace('.txt', '.csv')

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
    
# Rescale by whole brain mean
meandata = meandata.applymap(lambda x: x/float(denom))
print(meandata)

# Transpose
region = list(meandata.columns)
fracint = list(meandata.iloc[0,:].values)
result = pandas.DataFrame(zip(region, fracint), columns=['region','fractional_intensity'])

# Write to csv
result.to_csv(meanfslcsv, index=False)

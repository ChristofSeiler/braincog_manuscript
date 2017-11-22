#!/usr/bin/Rscript

library(SimpleITK)

args <- commandArgs(TRUE)
print(args)
inputFileName = args[1]
outputFileName = args[2]
lowerThreshold = as.numeric(args[3])
upperThreshold = as.numeric(args[4])

print(paste("inputFileName:",inputFileName))
print(paste("outputFileName:",outputFileName))
print(paste("lowerThreshold:",lowerThreshold))
print(paste("upperThreshold:",upperThreshold))

mask = ReadImage(inputFileName)
maxLabel = as.numeric(max(as.array(mask)))
binMask = BinaryThreshold(mask,lowerThreshold,upperThreshold)
WriteImage(binMask,outputFileName)

#!/usr/bin/Rscript

args <- commandArgs(TRUE)
print(args)
inputFileName = args[1]
outputFileName = args[2]
print(paste("inputFileName:",inputFileName))
print(paste("outputFileName:",outputFileName))

library(SimpleITK)

img = ReadImage(inputFileName)
WriteImage(Exp(img),outputFileName)

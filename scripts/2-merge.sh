#!/bin/sh

###
# Merge .tif tiles into a single layer.
#
# This script will merge each year tiles into a single mosaic .tif file.
#
# The script expects the following directory:
# - base: The base directory.
# -- data: Data directory.
# ---- merged: Merged layers.
# ---- individual: Individual tiles.
# ------ 2010: Tiles for year 2010.
# ------ ...
# -- scripts: The directory where this script is.
#
# The script expects the following parameters:
# $1: Base directory path.
###

# List of years:
years=("2010" "2017" "2018" "2019" "2020")

# Base destination path:
src_path="${1}/data/individual"

# Base destination path:
dst_path="${1}/data/merged"

# Iterate years:
for year in "${years[@]}"; do
	echo ""
	echo "======================="
	echo "==> MERGING YEAR ${year} ="
	echo "======================="
	gdal_merge.py -ot UInt16 -of GTiff -o "${dst_path}/${year}.tif" --optfile "${src_path}/${year}.txt"
done

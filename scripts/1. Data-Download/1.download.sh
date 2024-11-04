#!/bin/sh

###
# Download .tif files.
#
# Expects the following parameters:
# $1: Base directory path.
###

# List of years:
years=("2010" "2017" "2018" "2019" "2020")

# List of tiles:
tiles=("N30E000" "N30E010" "N30E020" "N30E030" "N30E040" "N30W010" "N30W020" "N40E000" "N40E010" "N40E020" "N40E030" "N40E040" "N40E050" "N40W010" "N40W020" "N40W030" "N50E000" "N50E010" "N50E020" "N50E030" "N50E040" "N50E050" "N50W010" "N60E000" "N60E010" "N60E020" "N60E030" "N60E040" "N60W010" "N60W020" "N70E000" "N70E010" "N70E020" "N70E030" "N70W010" "N70W020" "N70W030" "N80E010" "N80E020" "N80E030" "N80W010" "N80W020")

# External URL:
url="https://dap.ceda.ac.uk/neodc/esacci/biomass/data/agb/maps/v4.0/geotiff"

# Base destination path:
path="${1}/data/individual"

# Iterate years:
for year in "${years[@]}"; do
	echo ""
	for tile in "${tiles[@]}"; do
		# Get source path:
		source="${tile}_ESACCI-BIOMASS-L4-AGB-MERGED-100m-${year}-fv4.0.tif"
		echo "==> ${source}"
		
		# Make destination path:
		dest="${path}/${year}/${tile}-${year}.tif"
		
		# Download file:
		wget  --output-document="$dest" -e robots=off --mirror --no-parent "https://dap.ceda.ac.uk/neodc/esacci/biomass/data/agb/maps/v4.0/geotiff/${year}/${source}"
		if [ $? -ne 0 ]; then
			echo "!!! ERROR: unable to download ${tile}-${year}.tif"
			rm -f dest
		else
			echo "Downloaded file: ${tile}-${year}.tif"
		fi
	done
done

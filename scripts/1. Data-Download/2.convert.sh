#!/bin/sh

# List of years:
years=("2010" "2017" "2018" "2019" "2020")

# Base source path:
src_path="/Users/milko/Local/Data/Environment/Biomass/data/TIFF"

# Base destination path:
dst_path="/Users/milko/Local/Data/Environment/Biomass/data/GeoJSON"

# Base final path:
fin_path="/Users/milko/Local/Data/Environment/Biomass/data/JsonL"

# Iterate years:
for year in "${years[@]}"; do
	echo ""
	echo "YEAR: ${year}"
	for FILE in "${src_path}/${year}"/*.tif; do
		echo "Processing ${FILE}"
		if [ -f "$FILE" ]; then
			# Extract the base name without the .tif extension
			name=$(basename "$FILE" .tif)
			# Use the modified name with the new extension
			gdal_polygonize.py "$FILE" -f "GeoJSON" "${dst_path}/${year}/${name}.geojson"
			# Use jq to convert GeoJSON features to JSONL
			jq -c '.features[]' "${dst_path}/${year}/${name}.geojson" > "${fin_path}/${year}/${name}.jsonl"
		fi
	done
done

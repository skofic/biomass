from osgeo import gdal, ogr
import numpy as np
import json
import sys

def process_year(year, base_path, vector_path):
    try:
        # Open the raster file
        raster_path = f"{base_path}/data/merged/{year}.tif"
        raster_ds = gdal.Open(raster_path)
        if raster_ds is None:
            raise RuntimeError(f"Failed to open raster file: {raster_path}")

        vector_ds = ogr.Open(vector_path)
        if vector_ds is None:
            raise RuntimeError(f"Failed to open vector file: {vector_path}")

        # Set vector layer spacial reference
        vector_layer = vector_ds.GetLayer()
        spatial_ref = vector_layer.GetSpatialRef()
        if spatial_ref is None:
            # Set a default spatial reference if missing
            spatial_ref = osr.SpatialReference()
            spatial_ref.ImportFromEPSG(4326)  # Example: WGS84
            vector_layer.SetSpatialRef(spatial_ref)

        results = []

        for feature in vector_layer:
            geom = feature.GetGeometryRef()
            if geom is None:
                print(f"Warning: Geometry is None for feature ID {feature.GetFID()}")
                continue

            # Create a memory layer with a single feature
            mem_driver = ogr.GetDriverByName('Memory')
            mem_ds = mem_driver.CreateDataSource('')
            mem_layer = mem_ds.CreateLayer('', geom_type=ogr.wkbPolygon)
            mem_layer.CreateFeature(feature.Clone())  # Clone the feature

            # Create a memory raster to rasterize the feature
            mem_driver = gdal.GetDriverByName('MEM')
            mem_ds_raster = mem_driver.Create('', raster_ds.RasterXSize, raster_ds.RasterYSize, 1, gdal.GDT_Byte)
            mem_ds_raster.SetGeoTransform(raster_ds.GetGeoTransform())
            mem_ds_raster.SetProjection(raster_ds.GetProjection())

            # Rasterize the geometry of the current feature
            gdal.RasterizeLayer(mem_ds_raster, [1], mem_layer, burn_values=[1])

            # Read the mask and raster data
            mask_band = mem_ds_raster.GetRasterBand(1)
            mask_data = mask_band.ReadAsArray()

            raster_band = raster_ds.GetRasterBand(1)
            raster_data = raster_band.ReadAsArray()

            # Mask the raster data
            masked_data = np.ma.masked_array(raster_data, mask=(mask_data == 0))

            # Calculate statistics
            mean_val = masked_data.mean()
            std_val = masked_data.std()

            # Prepare the output record
            result = {
                "type": "Feature",
                "properties": {
                    "GeometryID": feature.GetField('GeometryID'),
                    "chr_CCI-AGB_avg": mean_val,
                    "chr_CCI-AGB_std": std_val
                },
                "geometry": json.loads(geom.ExportToJson())
            }
            results.append(result)

        # Write results to GeoJSONL
        output_path = f"{base_path}/data/result/unit_shapes_{year}.geojsonl"
        with open(output_path, 'w') as f:
            for feature in results:
                f.write(json.dumps(feature) + "\n")
        print(f"Successfully processed year {year}")

    except Exception as e:
        print(f"Error processing year {year}: {e}")

# Get the base path
base_path = sys.argv[1]

# Get the list of years
years = ["2010", "2017", "2018", "2019", "2020"]

# Get the shape file path
vector_path = f"{base_path}/data/shapes/unit_shapes.geojson"

# Iterate years
for year in years:
    print("")
    print("==========================")
    print(f"==> PROCESSING YEAR {year} =")
    print("==========================")
    process_year(year, base_path, vector_path)

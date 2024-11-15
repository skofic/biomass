1. Load Your Layers:
   - Open QGIS and load both your raster and polygon vector layers.
2. Verify Attribute Table:
   - Open the attribute table of your polygon layer to confirm that it contains the `hash` and `unit` fields.
3. Use the “Zonal Statistics” Tool:
   - Open the Processing Toolbox by going to `Processing` > `Toolbox`.
   - Search for “Zonal Statistics” in the toolbox.
   - Double-click on “Zonal Statistics” to open the tool.
4. Configure the Zonal Statistics Tool:
   - In the “Zonal Statistics” dialog, set the following parameters:
     - **Raster layer:** Select your raster layer with biomass values.
     - **Raster band:** Choose the appropriate band, typically band 1 if it’s a single-band raster.
     - **Vector layer containing zones:** Select your polygon layer.
     - **Output column prefix:** Enter a prefix for the output fields, e.g., `bio_`.
     - **Statistics to calculate:** Check “Mean” and “Standard deviation.”
   - Click “Run” to execute the tool.
5. Result Verification:
   - Once the tool completes, open the attribute table of the polygon layer.
   - You should see new fields added with the prefix you specified (e.g., `bio_mean` and `bio_stddev`), containing the average and standard deviation values for each polygon.
   - The original `hash` and `unit` fields will remain unchanged and available in the attribute table.
6. Export the Results:
   - If you want to save these results into a new file:
     - Right-click on your polygon layer in the Layers panel.
     - Select `Export` > `Save Features As...`.
     - Choose the desired format (e.g., GeoJSON, Shapefile).
     - Ensure all the fields, including `hash`, `unit`, `bio_mean`, and `bio_stddev`, are selected for export.
     - Click “OK” to save the file.
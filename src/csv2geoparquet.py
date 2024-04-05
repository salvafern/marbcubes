import geopandas as gpd
import os
import pandas as pd
from shapely.geometry import Point
import matplotlib.pyplot as plt
import cartopy.crs as ccrs

csvdir = 'samscode/csvs/bettercsvs'

for file in os.listdir(csvdir):
    #gdf = gpd.read_file(csvdir+ '/'+ file)
    df = pd.read_csv(csvdir+ '/'+ file)
    # Create a GeoDataFrame with the longitude and latitude as geometry
    geometry = [Point(xy) for xy in zip(df['longitude'], df['latitude'])]
    gdf = gpd.GeoDataFrame(df, geometry=geometry, crs='EPSG:4326')


    gdf.to_parquet(f"{csvdir}/{os.path.splitext(os.path.basename(file))[0]}_geo.parquet")


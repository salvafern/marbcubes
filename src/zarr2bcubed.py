import xarray as xr
import numpy as np

# Define the URL of the Zarr file
url = "https://s3.waw3-1.cloudferro.com/emodnet/bcubed/data/biooracle/chlorophyll/chl_baseline_2000_2018_depthsurf.zarr"

# Load the dataset
ds = xr.open_zarr(url)
print(ds)

# Define the slicing parameters
min_lon = -30
max_lon = 45
min_lat = 25
max_lat = 80
min_time = "2010-01-01"
max_time = "2020-01-01"

# Slice the dataset based on longitude and latitude
ds_sliced = ds.sel(longitude=slice(min_lon, max_lon), 
                   latitude=slice(min_lat, max_lat),
                   time=slice(min_time, max_time)
                   )

# Print the sliced dataset
print(ds_sliced)

# Extract dimension values and variable
lon = ds_sliced.longitude.values
lat = ds_sliced.latitude.values
time = ds_sliced.time.values
values = ds_sliced.chl_mean.values  # Assuming 'chl_mean' is the variable you want

# Add values of dimensions as dim names
values_dims = {'longitude': lon, 'latitude': lat, 'time': time}

# Reshape to long format
long_df = xr.DataArray(
    values,
    dims=["time", "latitude", "longitude"],  # Adjust dimensions order
    coords={"time": time, "latitude": lat, "longitude": lon}
).to_dataframe(name="chl_mean").reset_index()


#!/bin/bash

Array of URLs
urls=(
	"https://erddap.bio-oracle.org/erddap/files/thetao_baseline_2000_2019_depthsurf/climatologydecadedepthsurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/thetao_ssp119_2020_2100_depthsurf/climatologydecadedepthsurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/thetao_ssp585_2020_2100_depthsurf/climatologydecadedepthsurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/so_baseline_2000_2019_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/so_ssp119_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/so_ssp585_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/chl_baseline_2000_2018_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/chl_ssp119_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/chl_ssp585_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/sws_baseline_2000_2019_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/sws_ssp119_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/sws_ssp585_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/dfe_baseline_2000_2018_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/dfe_ssp119_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/dfe_ssp585_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/no3_baseline_2000_2018_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/no3_ssp119_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/no3_ssp585_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/par_mean_baseline_2000_2020_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/phyc_baseline_2000_2020_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/phyc_ssp119_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	"https://erddap.bio-oracle.org/erddap/files/phyc_ssp585_2020_2100_depthsurf/climatologyDecadeDepthSurf.nc"
	)

# Iterate over each URL
for url in "${urls[@]}"; do
    # Run the Docker command for each URL
    docker compose run netcdf-to-zarr python netcdf_to_zarr.py "$url"
done

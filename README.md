# Tackling Ocean Biodiversity Crisis with Marine Data B-Cubes

The goal of our project is to showcase a policy-relevant workflow using well-known methods of digital twinning and cloud computing.

We will download key datasets such as GBIF and OBIS occurrences, and environmental data from Copernicus Marine Service and Bio-Oracle. We will transform these datasets into parquet and zarr files that will be uploaded to S3 buckets and their endpoints will be recorded in a STAC catalogue.
We will read the datasets and transform into B-Cubes, than later we will use to fit species distribution models of two invasive species in the Mediterranean: the brown algae Rugulopteryx okamurae and the bluespotted cornetfish Fistularia commersonii. We will predict their potential habitat suitability in the future using different climate change scenarios.  Finally we will provide the models as B-Cubes, and we will provide policy insights on the result of the models.

## Abstract
The introduction of non-indigenous species is one of the major drivers of ocean biodiversity loss with an exponential growing rate yearly (IPBES 2019; UN World Ocean Assessment II, 2021). Agile tools for assessing potential risk of non-indigenous species are key to identifying native species and ecosystems at risk, which can be controlled with early detection and rapid mitigation responses (UN World Ocean Assessment II, 2021). Data-driven assessments such as Species Distribution Models (SDM) make use of FAIR biogeographic and environmental data. However, these typically come from heterogeneous sources and use different standards. Wrangling into a modelling-ready dataset is a time-consuming task that lags the integration into machine learning and modelling workflows. To boost this stage of modelling pipelines, finally enabling faster assessment of species invasion risks, we aim to bring model-ready data closer to SDM pipelines. We will funnel relevant biodiversity databases such as OBIS, GBIF or ETN, and environmental data sources such as Copernicus Marine Service or Bio-Oracle, into a Spatial Temporal Asset Catalog (STAC). This OGC-compliant specification aligns with the GBIF API. The STAC back-end will serve as an open-access entry point of ecological modelling-ready data cubes following the B-Cubes software specification. These B-Cubes will be compatible for plugging into machine learning and modelling workflows. We will showcase its potential for early risk assessment of non-indigenous species invasions with SDMs to calculate the probability of potential invasive species to colonise an area. We will build upon existing tools and develop new ones using well-known data science programming languages such as python or R, allowing reuse for other marine scientists, policy-makers and the wider community.

## Directory structure

- data
	- raw_data: read in here raw files
	- derived_data: any data that has been transformed goes here
- src: include here any relevant code
- report: include here any relevant output reports

## Relevant links
https://github.com/b-cubed-eu/hackathon-projects-2024/tree/main/projects/05

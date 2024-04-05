import requests

# Make a request to the GBIF API
gbif_response = requests.get('https://api.gbif.org/v1/species', params={'name': 'Felis catus'})

# Parse the response (assuming it's JSON)
gbif_data = gbif_response.json()

print(gbif_data)
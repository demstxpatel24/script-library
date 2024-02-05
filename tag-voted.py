import requests
import pandas as pd
import pandas_gbq

## GET DATA ##
# TODO: add query 
query = ''
df_totag = pandas_gbq.read_gbq(sql, project_id=project_id)
persons = df_totag.to_dict(orient = 'records')


## AUTHENTICATE TO REACH ## 
# TODO: reference API credentials from secrets

creds_payload = {"username": reach_api_username, 
                 "password": reach_api_password}
creds_req = requests.post("https://api.reach.vote/oauth/token", creds_payload)
creds_res = creds_req.json()["access_token"]
headers = {"Authorization": f"Bearer {creds_res}"}

## LEARN TAG ID ##
# TODO: Can hardcode with 'Voted' tag

tag_name = 'Test'
tag_id = ''
  
if tag_id == '':
  tags_req = requests.get("https://api.reach.vote/api/v1/tags", headers = headers)
  tags_res = tags_req.json()
  tag_id = [t for t in tags_res['tags'] if t['name'] == tag_name][0]['id']

## ADD TAGS ##
# TODO: Connect to voting data 

# for now, just test with Taral!
persons = [{'person_id':'29051875', 'person_id_type':'Voterfile VAN ID'}]

# Number of groups needed
import math
per_bin = 3000
n_bins = math.ceil(len(persons) / per_bin)

# Create status code audit
status_code = []
results = []

# Prep endpoint
endpoint = f"https://api.reach.vote/api/v1/tags/{tag_id}"

# Iterate over rows 
for i in range(n_bins):
    
    print(f'Starting chunk {i+1} of {n_bins}')
    people_bin = persons[i*per_bin : (i+1)*per_bin]
    payload = {"people": people_bin}
    req = requests.put(endpoint, json = payload, headers = headers)
    status_code.append(req.status_code)
    res = req.json()
    results.append(res)

## AUDIT THE SUCCESS ##
print(f'Number of People: {len(persons)}')
print(f'Number of Batches: {n_bins}')
print(f'Succeeded: {sum([s == 200 for s in status_code])}')
print(f'All succeeded?: {all(s == 200 for s in status_code)}')
     

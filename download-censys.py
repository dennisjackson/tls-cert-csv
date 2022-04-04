#!/usr/bin/env python3

import requests
import json
import os 
from datetime import datetime
import config
from pprint import pprint

url = "https://search.censys.io/api/v1/search/certificates"

def make_body(page): 
  return json.dumps({
  "query": "parsed.issuer.organization.raw: \"The Ministry of Digital Development and Communications\"",
  "fields": [
    "parsed.fingerprint_sha256",
    "parsed.subject_dn",
    "parsed.issuer_dn",
    "parsed.issuer.organization",
    "parsed.validity.start",
    "parsed.validity.end",
    "parsed.names",
    "metadata.source",
    "metadata.added_at",
    "ct"
  ],
  "page": page,
  "flatten": False
})

def extract_pages(str):
  j = json.loads(str)
  if "status" in j.keys():
    if j['status'] == "error": 
      pprint(j)
      exit(-1)
  return int(j['metadata']['pages'])

auth_header = config.header
if auth_header is None:
  print("No authorisation header set")
  exit(-1)

outdir=f'lists/censys-raw/{datetime.now().strftime("%Y%m%d-%H%M")}'
os.makedirs(f"{outdir}",exist_ok=True)

p = 1 
pages = 0
while p != pages:
  #print(f"Fetching page {p}")
  payload = make_body(p)
  headers = {
    'Content-Type': 'application/json',
    'Authorization': auth_header 
  }
  response = requests.request("POST", url, headers=headers, data=payload)
  pages = extract_pages(response.text)
  pprint(pages)
  f = open(f"{outdir}/{p}.json","w")
  f.write(response.text)
  f.close()

print(f"Output {p} pages to {outdir}")
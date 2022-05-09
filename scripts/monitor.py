#!/usr/bin/env python3

import requests

links = [
    "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-cosigned",
    "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-to-cosign",
    "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-leaves/0/1",
    "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-consistency-proof/1/3",
]

for url in links:
    response = requests.get(url)
    if response.status_code != 200:
        print(f"{url} is not returing 200.")
    else:
        print(f"{url} is working.")

 #!/bin/bash

links=("https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-cosigned" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-to-cosign" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-leaves/0/1" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-consistency-proof/1/3")

for url in ${links[@]};
do
echo $url #this is for testing purpose. To be removed in thhe final code.
  response=$(curl -s -w "%{http_code}" $url)
  http_code=$(tail -n1 <<< "$response")
  if [[ "$http_code" != 200 ]]; then
    echo Fatal. $url is down. status_code $http_code
    domain_name=$(echo $url | awk -F[/:] '{print $4}')
    echo $domain_name
    # 1. Find IP address via dig
    # 2. Check if we can ping the ip address
    ip_address=$(dig +short $domain_name)
    echo $dig_response #this is for testing purpose. To be removed in thhe final code.
    #ping_response=$(ping $ip_address)
  else
    echo $url is working.  status_code $http_code
   fi
done



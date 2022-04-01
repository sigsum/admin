#! /usr/bin/env bash
set -eu

# Test fetching a HTTP(S) URL and complain if the response code is not
# 200.

# Example usage:
# for proto in http https; do
#   for url in er3n3jnvoyj2t37yngvzr35b6f4ch5mgzl3i6qlkvyhzmaxo62nlqmqd.onion www.sigsum.org sigsum.org; do
#     ~/src/testurl.sh $proto://$url/
# done; done

URL="$1"; shift

curl="curl"
echo "$URL" | grep -q \\.onion && curl="$curl -x socks4a://127.0.0.1:9050/"

function testurl() {
    family="-$1"
    response=$($curl "$family" -L -s -w "%{http_code}" "$URL")
    http_code=$(tail -n1 <<< "$response")

    if [[ "$http_code" != 200 ]]; then
	echo "$URL: $http_code"
	false
    fi
}

for fam in 4 6; do
    testurl $fam
done

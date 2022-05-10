 #!/bin/bash

# Need to add cleanup function to remove the log_dir in the next phase (if required).
# trap cleanup EXIT


function safe_methods() {

  links=("https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-cosigned" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-to-cosign" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-leaves/0/1" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-consistency-proof/1/3")

  for url in ${links[@]};
  do
    response=$(curl -s -w "%{http_code}" $url)
    http_code=$(tail -n1 <<< "$response")
    domain_name=$(echo $url | awk -F[/:] '{print $4}')
    if [[ "$http_code" != 200 ]]; then
      msg="Warning: $url is down. status_code $http_code"
      echo $msg | mail -s "Warning: $domain_name is down" anwesha@verkligendata.se
    else
      echo $url is working.  status_code $http_code
    fi
  done

}

function main() {
  safe_methods
  log_dir=$(mktemp -d)
  res=$(curl -s https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-leaves/0/1)
  resarray=($res)
  export ${resarray[0]}  # getting the shard_hint value
  export seed_value=`date +%s` # getting the message
  cli_priv=`cat ./priv`
  cli_pub=`cat ./pub`
  cli_domain_hint=_sigsum_v0.sigsum.org
  log_url=https://poc.sigsum.org/crocodile-icefish/sigsum/v0/
  test_add_leaf $seed_value
}

function test_add_leaf() {
        desc="POST add-leaf (data \"$1\")"
        echo "shard_hint=$shard_hint" > $log_dir/req
        echo "message=$(openssl dgst -binary <(echo $1) | base16)" >> $log_dir/req
        echo "signature=$(echo $1 |
                sigsum-debug leaf sign -k $cli_priv -h $shard_hint)" >> $log_dir/req
        echo "public_key=$cli_pub" >> $log_dir/req
        echo "domain_hint=$cli_domain_hint" >> $log_dir/req
        cat $log_dir/req |
                curl -s -w "%{http_code}" --data-binary @- /add-leaf \
                >$log_dir/rsp
        status_code=$(tail -n1 < $log_dir/rsp)

        if [[ $status_code != 200 ]]; then
                fail "$desc: http status code $status_code" # send mail
                return
        fi

        pass $desc
}

function info() {
	echo -e "\e[37m$(date +"%y-%m-%d %H:%M:%S %Z")\e[0m [\e[94mINFO\e[0m] $@" >&2
}

function warn() {
	echo -e "\e[37m$(date +"%y-%m-%d %H:%M:%S %Z")\e[0m [\e[93mWARN\e[0m] $@" >&2
}

function pass() {
	echo -e "\e[37m$(date +"%y-%m-%d %H:%M:%S %Z")\e[0m [\e[32mPASS\e[0m] $@" >&2
}

function fail() {
	echo -e "\e[37m$(date +"%y-%m-%d %H:%M:%S %Z")\e[0m [\e[91mFAIL\e[0m] $@" >&2
}


main
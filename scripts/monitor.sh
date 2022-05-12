#!/bin/bash

# Need to add cleanup function to remove the log_dir in the next phase (if required).
# trap cleanup EXIT

env -i
set -x

function safe_methods() {

  links=("https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-cosigned" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-to-cosign" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-leaves/0/1" "https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-consistency-proof/1/3")

  for url in ${links[@]};
  do
    response=$(curl -s -w "%{http_code}" $url)
    http_code=$(tail -n1 <<< "$response")
    domain_name=$(echo $url | awk -F[/:] '{print $4}')
    api=$url
    if [ $http_code != 200 ]; then
      msg="$(date +"%y-%m-%d %H:%M:%S %Z") Warning: $url is down. status_code $http_code"
      fail "$msg"
    else
      echo $url is working.  status_code $http_code
    fi
  done

}

function get_tree_size() {
  res=$(curl -s https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-tree-head-cosigned)
  resarray=($res)
  export ${resarray[1]}
  echo $tree_size
}

function main() {
  # Used the current poc log pub_key from https://git.sigsum.org/log-go/tree/README.md
  log_pub_key=4791eff3bfc17f352bcc76d4752b38c07882093a5935a84577c63de224b0f6b3
  log_pub_key_hash=$(echo $log_pub_key | sigsum-debug key hash)
  # Calling all get_methods
  safe_methods
  # Creates a new temporary directory for the test run
  log_dir=$(mktemp -d)
  # Storing `get-leaves` output in `res`
  res=$(curl -s https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-leaves/0/1)
  # Converting `$res` in an array spliting by space
  # To see the whole array try : `echo ${resarray[*]}`
  resarray=($res)
  # Exporting the first value of the resarray, shard_hint value
  export ${resarray[0]}
  # Exporting the `shard_hint` value in `ssrv_shard_start`
  export ssrv_shard_start=$shard_hint
  # Everytime message in add_leaf has to unique. Using the `date +%s`` for that.
  # Exporting the value of date +%s command in seed_value (tobe used as message)
  export seed_value=`date +%s`
  # Generated all the following private, public and hash of public key via sigsum-debug tool.
  # See `sigsum-debug key help`
  # `./priv` contains the private key of the signer/submitter
  cli_priv=`cat ./priv`
  # `./pub` contains the public key of the signer/submitter
  # `./pub`, the public key has to be added to the log first time before trying the code.
  cli_pub=`cat ./pub`
  # `./pubhash` contains the hash public key of the signer/submitter
  cli_key_hash=`cat ./pubhash`
  cli_domain_hint=_sigsum_v0.sigsum.org
  log_url=https://poc.sigsum.org/crocodile-icefish/sigsum/v0
  check_add_leaf $seed_value
  wit1_priv=`cat wit1_priv`
  wit1_pub=`cat wit1_pub`
  wit1_key_hash=`cat wit1_pubhash`
  # We don't know how much to sleep
  sleep 480
  get_tree_size
  check_inclusion_proof $tree_size $seed_value
  check_add_cosignature $wit1_key_hash $wit1_priv
}

function check_add_leaf() {
  desc="POST add-leaf (data \"$1\")"
  echo "shard_hint=$shard_hint" > $log_dir/req
  echo "message=$(openssl dgst -binary <(echo $1) | base16)" >> $log_dir/req
  echo "signature=$(echo $1 |
    sigsum-debug leaf sign -k $cli_priv -h $shard_hint)" >> $log_dir/req
  echo "public_key=$cli_pub" >> $log_dir/req
  echo "domain_hint=$cli_domain_hint" >> $log_dir/req
  cat $log_dir/req |
    curl -s -w "%{http_code}" --data-binary @- $log_url/add-leaf \
        >$log_dir/rsp

  status_code=$(tail -n1 < $log_dir/rsp)
  api=$log_url/add-leaf

  if [ $status_code == 202 ]; then
    msg="Info: $api request is Accepted with status_code $http_code"
    echo $msg
  elif [ $status_code != 200 ]; then
    msg="$(date +"%y-%m-%d %H:%M:%S %Z") Warning: $api is down with status_code $status_code" # Failure message
    fail "$msg" # calling the fail function
    return
  fi

  pass $desc
}

function check_inclusion_proof() {
	desc="GET get-inclusion-proof (tree_size $1, data \"$2\")"
	signature=$(echo $2 | sigsum-debug leaf sign -k $cli_priv -h $ssrv_shard_start)
	leaf_hash=$(echo $2 | sigsum-debug leaf hash -k $cli_key_hash -s $signature -h $ssrv_shard_start)
  api=$log_url/get-inclusion-proof/$1/$leaf_hash
	curl -s -w "%{http_code}" $api >$log_dir/rsp
  cp $log_dir/rsp $log_dir/rsp_get_inclusion_proof
  status_code=$(tail -n1 < $log_dir/rsp)


	if [[ $status_code != 200 ]]; then
    msg="$(date +"%y-%m-%d %H:%M:%S %Z") Warning: $api is down with status_code $status_code" # Failure message
    fail "$msg" # calling the fail function
		return
	fi

	pass $desc
}

function check_add_cosignature() {
	desc="POST add-cosignature (witness $1)"
	echo "key_hash=$1" > $log_dir/req
	echo "cosignature=$(curl -s $log_url/get-tree-head-to-cosign |
		sigsum-debug head sign -k $2 -h $log_pub_key_hash)" >> $log_dir/req
	cat $log_dir/req |
		curl -s -w "%{http_code}" --data-binary @- $log_url/add-cosignature \
		>$log_dir/rsp
  status_code=$(tail -n1 < $log_dir/rsp)
  api=$log_url/add-cosignature

  if [ "$status_code" != 200 ]; then
    msg="$(date +"%y-%m-%d %H:%M:%S %Z") Warning:$api is down with status_code $status_code"
    fail "$msg"
  else
    msg="Success: $api is working with status_code $status_code."
    echo "$msg"
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
  echo $1 |  mail -s "Warning: $api is down" sigsum-log-monitor@lists.sigsum.org
}

function keys() {
	declare -A map
	map[thedummystring]=to_avoid_error_on_size_zero
	while read line; do
		key=$(echo $line | cut -d"=" -f1)
		map[$key]=ok
	done < <(head --lines=-1 $log_dir/rsp)

	if [[ $# != $(( ${#map[@]} - 1 )) ]]; then
		return 1
	fi
	for key in $@; do
		if [[ -z ${map[$key]} ]]; then
			return 1
		fi
	done
	return 0
}

function value_of() {
	while read line; do
		key=$(echo $line | cut -d"=" -f1)
		if [[ $key != $1 ]]; then
			continue
		fi

		value=$(echo $line | cut -d"=" -f2)
		echo $value
	done < <(head --lines=-1 $log_dir/rsp)
}

main

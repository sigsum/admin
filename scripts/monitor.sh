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
    if [ $http_code != 200 ]; then
      msg="Warning: $url is down. status_code $http_code"
      echo $msg | mail -s "Warning: $domain_name is down" anwesha@verkligendata.se
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

  log_pub_key=4791eff3bfc17f352bcc76d4752b38c07882093a5935a84577c63de224b0f6b3
  log_pub_key_hash=$(echo $log_pub_key | sigsum-debug key hash)

  safe_methods
  log_dir=$(mktemp -d)
  res=$(curl -s https://poc.sigsum.org/crocodile-icefish/sigsum/v0/get-leaves/0/1)
  resarray=($res)
  export ${resarray[0]}  # getting the shard_hint value
  export ssrv_shard_start=$shard_hint
  export seed_value=`date +%s` # getting the message
  cli_priv=`cat ./priv`
  cli_pub=`cat ./pub`
  cli_key_hash=`cat ./pubhash`
  cli_domain_hint=_sigsum_v0.sigsum.org
  log_url=https://poc.sigsum.org/crocodile-icefish/sigsum/v0
  get_tree_size
  check_add_leaf $seed_value
  api=add-leaf
  wit1_priv=`cat wit1_priv`
  wit1_pub=`cat wit1_pub`
  wit1_key_hash=`cat wit1_pubhash`
  old_tree_size=$tree_size
  # We don't know how much to sleep
  sleep 480
  get_tree_size
  test_inclusion_proof $tree_size $seed_value $old_tree_size
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
  api=add_leaf
  if [ $status_code == 202 ]; then
    msg="Info: $api request is Accepted with status_code $http_code"
    echo $msg #| mail -s "Info: $api Accepted" anwesha@verkligendata.se
    # Acceptance Message
  elif [ $status_code != 200 ]; then
    msg="Warning: $api is down with status_code $status_code"
    echo $msg #| mail -s "Warning: $api is down" anwesha@verkligendata.se
    # Failure message
    return
  fi

  pass $desc
}

function test_inclusion_proof() {
	desc="GET get-inclusion-proof (tree_size $1, data \"$2\", index $3)"
	signature=$(echo $2 | sigsum-debug leaf sign -k $cli_priv -h $ssrv_shard_start)
	leaf_hash=$(echo $2 | sigsum-debug leaf hash -k $cli_key_hash -s $signature -h $ssrv_shard_start)
	curl -s -w "%{http_code}" $log_url/get-inclusion-proof/$1/$leaf_hash >$log_dir/rsp
  cp $log_dir/rsp $log_dir/rsp_get_inclusion_proof
  status_code=$(tail -n1 < $log_dir/rsp)

	if [[ $status_code != 200 ]]; then
		fail "$desc: http status code $status_code  "
		return
	fi

	if ! keys "leaf_index" "inclusion_path"; then
		fail "$desc: ascii keys in response $(debug_response)"
		return
	fi

	if [[ $(value_of leaf_index) != $3 ]]; then
		fail "$desc: wrong leaf index $(value_of leaf_index)"
		return
	fi

	# TODO: verify inclusion proof
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
    if [ "$status_code" != 200 ]; then
      msg="Warning: $log_url/add-cosignature is down. status_code $status_code"
      echo $msg #| mail -s "Warning: $domain_name is down" anwesha@verkligendata.se
    else
      echo $log_url/add-cosignature is working.  status_code $status_code
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
#!/usr/bin/env bash
set -eou pipefail
cd "$(dirname "$0")"

# Currently, this is mandatory or we'll not find the jq in PATH:
export PATH="$(pwd):$PATH"

# DEBUG code:
#echo "PWD=$PWD; PATH=$PATH; FILES=$(echo * | tr ' ' ';')"

source ./check-bin.sh && check-bin jq

declare -r INVALID_JSON="The JSON passed as an input is invalid!\n%s\n"
new_value=$1
jq_error=$(mktemp)
if ! [ -t 0 ]
then
	if [ "$new_value" ]
	then
		if ouput=$(jq -c ".value=\"$new_value\"" 2> $jq_error)
		then
			if key=$(jq -r .key <<< "$ouput") && [ $key != null ]
			then
				echo "$ouput" | \
				# DEBUG code inserted:
				jq -c ".jq=\"$(type -P jq)\"" | \
				# production code:
				tee /tmp/$key.updated.json
			else
				printf "$INVALID_JSON" "Key not found"
			fi
		else
			printf "$INVALID_JSON" "$(cat $jq_error)"
		fi
	else
		echo "No value provided!"
	fi
elif [ -n "$new_value" ]
then
	echo -e "No JSON input was provided!\nJust echoing the value provided: $new_value"
else
	echo "No JSON input and no value provided!"
fi

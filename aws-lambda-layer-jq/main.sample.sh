#!/bin/bash

echo "---[PATH]---"
echo $PATH | tr ':' '\n'
echo "---[/PATH]---"

echo "---[BINARIES location]---"
echo "jq=$(type -P jq)"
echo "---[/BINARIES location]---"

echo
echo "---[payload]---"
stdin=$(test -s /dev/stdin && cat -)
if [ "${stdin}X" != "X" ]
then
    payload="$stdin"
else
    payload="$1"
fi
echo $payload
echo "---[/payload]---"

echo
instanceId=$(echo $payload | jq -r .instanceId)
echo "instanceId=$instanceId"

# your business logic here to handle $instanceId
# ...

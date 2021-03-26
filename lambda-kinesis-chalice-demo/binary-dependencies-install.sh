#!/usr/bin/env bash

mkdir -p vendor

[ -f vendor/jq ] || {
	echo "Installing jq dependency ..."
	wget -q -c -O vendor/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
	chmod +x vendor/jq
}

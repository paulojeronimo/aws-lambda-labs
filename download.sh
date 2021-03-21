#!/usr/bin/env bash

repo=aws-lambda-labs
curl -L https://github.com/paulojeronimo/$repo/archive/refs/heads/main.tar.gz |
	tar -xz
mv $repo-main $repo

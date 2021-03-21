#!/usr/bin/env bash
set -eou pipefail
declare -r repo=https://github.com/paulojeronimo/aws-lambda-labs
declare -r dir=${repo##*/}
curl -sL $repo/archive/refs/heads/main.tar.gz | tar -xz
mv $dir-main $dir && cd $_

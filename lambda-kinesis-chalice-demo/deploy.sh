#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source ./common.sh

venv-setup() {
	[ -d venv ] || {
		echo "Creating the virtual environment (venv) ..."
		python3 -m venv venv
		echo "Upgrading pip ..."
		pip3 install --upgrade pip
		echo "Installing the Python requirements ..."
		pip3 install -r requirements.txt
	}
}

venv-activate() {
	if ! [ "${VIRTUAL_ENV:-}" ] || [ "$VIRTUAL_ENV" != "$BASE_DIR"/venv ]
	then
		echo "Activating the virtual environment (venv) ..."
		[ -d venv ] || {
			echo "Could not activate!"
			exit 1
		}
		source ./venv/bin/activate 2>&- || {
			echo "Could not activate!"
			exit 1
		}
	fi
}

check-bin python3 pip3
./aws-setup.sh is-done || ./aws-setup.sh
venv-setup
venv-activate
check-bin chalice
#./binary-dependencies-install.sh <- commented out since we are now using an AWS Lambda Layer (see the configuration in ./.chalice.config.json)
chalice deploy

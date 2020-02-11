#!/usr/bin/env bash
#

set -xeuo pipefail

check_config='check-config.sh'

wget -O "${check_config}" https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh
chmod +x "${check_config}"

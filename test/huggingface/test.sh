#!/bin/bash

set -e

source dev-container-features-test-lib
source /usr/local/bin/activate-huggingface
source "$(dirname "$0")/common_checks.sh"

# Perform common checks
check_common

# Report result
reportResults
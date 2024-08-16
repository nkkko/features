#!/bin/bash

set -e

source dev-container-features-test-lib
source /usr/local/bin/activate-huggingface
source "$(dirname "$0")/common_checks.sh"

# Perform common checks
check_common

# Check if the installed version is 4.28.1 (as specified in scenarios.json)
INSTALLED_VERSION=$(pip show transformers | grep Version | awk '{print $2}')
check "transformers is version 4.28.1" [ "$INSTALLED_VERSION" = "4.28.1" ]

reportResults
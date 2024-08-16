#!/bin/bash

set -e

source dev-container-features-test-lib
source /usr/local/bin/activate-huggingface
source "$(dirname "$0")/common_checks.sh"

# Perform common checks
check_common

# Check if the installed version is the latest
INSTALLED_VERSION=$(pip show transformers | grep Version | awk '{print $2}')
LATEST_VERSION=$(pip install transformers== 2>&1 | grep -oP '(?<=\(from versions: ).*(?=\))' | tr ',' '\n' | sort -V | tail -n 1)

echo "Installed version: $INSTALLED_VERSION"
echo "Latest version: $LATEST_VERSION"

if [ "$INSTALLED_VERSION" = "$LATEST_VERSION" ]; then
    echo "Transformers is at the latest version."
    check "transformers is latest" [ "$INSTALLED_VERSION" = "$LATEST_VERSION" ]
else
    echo "Warning: Transformers is not at the latest version."
    check "transformers is latest" [ "$INSTALLED_VERSION" = "$LATEST_VERSION" ]
fi

reportResults
#!/bin/bash

set -e

source dev-container-features-test-lib

source /usr/local/bin/activate-huggingface

check "python version" python --version
check "pip version" pip --version
check "transformers installed" python -c "import transformers; print(transformers.__version__)"
check "torch installed" python -c "import torch; print(torch.__version__)"
check "datasets installed" python -c "import datasets; print(datasets.__version__)"
check "tokenizers installed" python -c "import tokenizers; print(tokenizers.__version__)"
check "sentencepiece installed" python -c "import sentencepiece; print(sentencepiece.__version__)"
check "huggingface_hub installed" python -c "import huggingface_hub; print(huggingface_hub.__version__)"

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
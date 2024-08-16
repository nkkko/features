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

# Check if the installed version is 4.28.1 (as specified in scenarios.json)
INSTALLED_VERSION=$(pip show transformers | grep Version | awk '{print $2}')
check "transformers is version 4.28.1" [ "$INSTALLED_VERSION" = "4.28.1" ]

reportResults
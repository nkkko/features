#!/bin/bash

# This test file will be executed against the 'huggingface_latest' scenario.

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Activate the Hugging Face virtual environment
source /usr/local/bin/activate-huggingface

# Feature-specific tests
check "python version" python --version
check "pip version" pip --version
check "transformers installed" python -c "import transformers; print(transformers.__version__)"
check "torch installed" python -c "import torch; print(torch.__version__)"
check "datasets installed" python -c "import datasets; print(datasets.__version__)"
check "tokenizers installed" python -c "import tokenizers; print(tokenizers.__version__)"
check "sentencepiece installed" python -c "import sentencepiece; print(sentencepiece.__version__)"
check "huggingface_hub installed" python -c "import huggingface_hub; print(huggingface_hub.__version__)"

# Check if the installed version is the latest
check "transformers is latest" [ "$(pip list | grep transformers | awk '{print $2}')" = "$(pip install transformers== 2>&1 | grep -oP '(?<=\(from versions: ).*(?=\))' | tr ',' '\n' | sort -V | tail -n 1)" ]

# Report result
reportResults
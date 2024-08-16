#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'huggingface' feature with no options.

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

# Report result
reportResults
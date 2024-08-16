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

# Check if CUDA is available
CUDA_AVAILABLE=$(python -c "import torch; print(torch.cuda.is_available())")
echo "CUDA available: $CUDA_AVAILABLE"

if [ "$CUDA_AVAILABLE" = "True" ]; then
    echo "CUDA is available."
    check "CUDA is available" [ "$CUDA_AVAILABLE" = "True" ]
else
    echo "Error: CUDA is not available."
    check "CUDA is available" [ "$CUDA_AVAILABLE" = "True" ]
fi

# Additional CUDA information
if [ "$CUDA_AVAILABLE" = "True" ]; then
    CUDA_VERSION=$(python -c "import torch; print(torch.version.cuda)")
    echo "CUDA version: $CUDA_VERSION"

    GPU_COUNT=$(python -c "import torch; print(torch.cuda.device_count())")
    echo "Number of GPUs: $GPU_COUNT"

    for i in $(seq 0 $((GPU_COUNT-1))); do
        GPU_NAME=$(python -c "import torch; print(torch.cuda.get_device_name($i))")
        echo "GPU $i: $GPU_NAME"
    done
fi

reportResults
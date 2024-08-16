#!/bin/bash
set -e

echo "Activating feature 'huggingface'"

# Parse input arguments
VERSION="${VERSION:-latest}"
CUDA="${CUDA:-false}"

# Ensure Python and pip are available
if ! command -v python3 &> /dev/null || ! command -v pip3 &> /dev/null; then
    apt-get update
    apt-get install -y python3 python3-pip python3-venv
fi

# Create a virtual environment
VENV_PATH="/opt/huggingface-venv"
python3 -m venv $VENV_PATH

# Activate the virtual environment
source $VENV_PATH/bin/activate

# Upgrade pip and install required packages
pip install --upgrade pip
if [ "$VERSION" = "latest" ]; then
    pip install transformers
else
    pip install "transformers==$VERSION"
fi

# Install PyTorch
if [ "$CUDA" = "true" ]; then
    pip install torch torchvision torchaudio
else
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
fi

# Install other Hugging Face libraries
pip install datasets tokenizers sentencepiece huggingface_hub

# Create a script to activate the virtual environment
echo "source $VENV_PATH/bin/activate" > /usr/local/bin/activate-huggingface
chmod +x /usr/local/bin/activate-huggingface
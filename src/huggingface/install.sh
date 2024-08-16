#!/bin/bash
set -e

echo "Activating feature 'huggingface'"

# Parse input arguments
VERSION="${VERSION:-"latest"}"
CUDA="${CUDA:-"false"}"

# Ensure Python is available
if ! command -v python3 &> /dev/null; then
    echo "Python is not installed. Installing Python..."
    apt-get update
    apt-get install -y python3 python3-pip python3-venv
fi

# Create a virtual environment
VENV_PATH="/opt/huggingface-venv"
python3 -m venv $VENV_PATH

# Activate the virtual environment
source $VENV_PATH/bin/activate

# Install Hugging Face Transformers
echo "Installing Hugging Face Transformers ${VERSION}..."
if [ "${VERSION}" = "latest" ]; then
    pip install transformers
else
    pip install transformers==${VERSION}
fi

# Install PyTorch
if [ "${CUDA}" = "true" ]; then
    echo "Installing PyTorch with CUDA support..."
    pip install torch torchvision torchaudio
else
    echo "Installing PyTorch without CUDA support..."
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
fi

# Install other common Hugging Face libraries
echo "Installing additional Hugging Face libraries..."
pip install datasets tokenizers sentencepiece

# Install Hugging Face CLI
echo "Installing Hugging Face CLI..."
pip install huggingface_hub

# Create a script to activate the virtual environment
echo "Creating activation script..."
cat << EOF > /usr/local/bin/activate-huggingface
#!/bin/bash
source $VENV_PATH/bin/activate
EOF
chmod +x /usr/local/bin/activate-huggingface

echo "Hugging Face feature installation complete."
echo "To activate the Hugging Face environment, run: source /usr/local/bin/activate-huggingface"
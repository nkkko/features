#!/bin/bash
set -e

echo "Activating feature 'huggingface'"

# Parse input arguments
VERSION="${VERSION:-"latest"}"
CUDA="${CUDA:-"false"}"

echo "Installation parameters:"
echo "VERSION: $VERSION"
echo "CUDA: $CUDA"

# Ensure Python and pip are available
if ! command -v python3 &> /dev/null || ! command -v pip3 &> /dev/null; then
    echo "Installing Python and pip..."
    apt-get update
    apt-get install -y python3 python3-pip python3-venv
else
    echo "Python and pip are already installed."
fi

# Create a virtual environment
VENV_PATH="/opt/huggingface-venv"
echo "Creating virtual environment at $VENV_PATH"
python3 -m venv $VENV_PATH

# Activate the virtual environment
source $VENV_PATH/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install Hugging Face Transformers
echo "Installing Hugging Face Transformers ${VERSION}..."
if [ "${VERSION}" = "latest" ]; then
    pip install transformers
else
    pip install transformers==${VERSION}
fi

# Verify Transformers installation
if python -c "import transformers; print(transformers.__version__)" &> /dev/null; then
    echo "Transformers installed successfully."
else
    echo "Error: Failed to install Transformers."
    exit 1
fi

# Install PyTorch
if [ "${CUDA}" = "true" ]; then
    echo "Installing PyTorch with CUDA support..."
    pip install torch torchvision torchaudio
else
    echo "Installing PyTorch without CUDA support..."
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
fi

# Verify PyTorch installation
if python -c "import torch; print(torch.__version__)" &> /dev/null; then
    echo "PyTorch installed successfully."
    if [ "${CUDA}" = "true" ]; then
        if python -c "import torch; print(torch.cuda.is_available())" | grep -q "True"; then
            echo "CUDA is available for PyTorch."
        else
            echo "Warning: CUDA is not available for PyTorch, despite being requested."
        fi
    fi
else
    echo "Error: Failed to install PyTorch."
    exit 1
fi

# Install other common Hugging Face libraries
echo "Installing additional Hugging Face libraries..."
pip install datasets tokenizers sentencepiece

# Verify additional libraries installation
for lib in datasets tokenizers sentencepiece; do
    if python -c "import $lib; print(${lib}.__version__)" &> /dev/null; then
        echo "$lib installed successfully."
    else
        echo "Error: Failed to install $lib."
        exit 1
    fi
done

# Install Hugging Face CLI
echo "Installing Hugging Face CLI..."
pip install huggingface_hub

# Verify Hugging Face CLI installation
if python -c "import huggingface_hub; print(huggingface_hub.__version__)" &> /dev/null; then
    echo "Hugging Face CLI installed successfully."
else
    echo "Error: Failed to install Hugging Face CLI."
    exit 1
fi

# Create a script to activate the virtual environment
echo "Creating activation script..."
cat << EOF > /usr/local/bin/activate-huggingface
#!/bin/bash
source $VENV_PATH/bin/activate
EOF
chmod +x /usr/local/bin/activate-huggingface

echo "Hugging Face feature installation complete."
echo "To activate the Hugging Face environment, run: source /usr/local/bin/activate-huggingface"
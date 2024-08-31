#!/bin/bash
set -e

echo "Activating feature 'huggingface'"

# Parse input arguments
VERSION="${VERSION:-latest}"
CUDA="${CUDA:-false}"

# Function to install Python packages
install_python_package() {
    local package_name=$1
    local package_version=$2
    if [ "$package_version" = "latest" ]; then
        pip install $package_name
    else
        pip install "$package_name==$package_version"
    fi
}

# Ensure Python and pip are available
if ! command -v python3 &>/dev/null; then
    apt-get update && apt-get install -y python3 python3-pip python3-venv
else
    echo "Python3 is already installed."
fi

# Ensure python3-venv is installed
if ! dpkg -s python3-venv &>/dev/null; then
    apt-get update && apt-get install -y python3-venv
else
    echo "python3-venv is already installed."
fi

# Set up a virtual environment if not present
VENV_PATH="/opt/huggingface-venv"
if [ ! -d "$VENV_PATH" ]; then
    python3 -m venv $VENV_PATH
    echo "Virtual environment created at $VENV_PATH."
else
    echo "Using existing virtual environment at $VENV_PATH."
fi

# Activate the virtual environment
source $VENV_PATH/bin/activate

# Upgrade pip to the latest version
pip install --upgrade pip

# Install required Python packages
install_python_package "transformers" "$VERSION"

# Install PyTorch with or without CUDA support
if [ "$CUDA" = "true" ]; then
    pip install torch torchvision torchaudio
else
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
fi

install_python_package "datasets" "$DATASETS_VERSION"
install_python_package "tokenizers" "$TOKENIZERS_VERSION"
pip install sentencepiece huggingface_hub

# Create a script to activate the virtual environment
cat <<EOL >/usr/local/bin/activate-huggingface
#!/bin/bash
source $VENV_PATH/bin/activate
EOL
chmod +x /usr/local/bin/activate-huggingface

echo "Hugging Face setup completed successfully."

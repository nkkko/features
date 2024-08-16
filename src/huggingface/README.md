# Hugging Face DevContainer Feature

This repository contains a DevContainer Feature for setting up a Hugging Face environment in your development container. It provides an easy way to install Hugging Face libraries and tools for machine learning and natural language processing tasks.

## Features

- Hugging Face Transformers
- PyTorch (with optional CUDA support)
- Hugging Face Datasets
- Tokenizers
- SentencePiece
- Hugging Face Hub CLI

## Usage

To use this feature in your devcontainer, add it to your `devcontainer.json` file:

```json
"features": {
    "ghcr.io/nkkko/devcontainer-huggingface-feature/huggingface:1": {
        "version": "latest",
        "cuda": false
    }
}
```

### Options

| Option | Default | Description |
|--------|---------|-------------|
| version | "latest" | Version of Hugging Face Transformers to install |
| cuda | false | Whether to install CUDA-enabled version of PyTorch |

## Development

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Docker](https://www.docker.com/)

### Setup

1. Clone this repository:
   ```
   git clone https://github.com/nkkko/devcontainer-huggingface-feature.git
   cd devcontainer-huggingface-feature
   ```

2. Open the project in VS Code:
   ```
   code .
   ```

3. When prompted, click "Reopen in Container" to develop inside a container with the necessary tools installed.

### Testing

This project uses GitHub Actions to automatically test the feature. You can also test locally using the Dev Container CLI:

```bash
devcontainer features test -f huggingface -i mcr.microsoft.com/devcontainers/base:ubuntu .
```

### Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Release Process

This project uses GitHub Actions to automatically release new versions of the feature. The release process is triggered manually:

1. Go to the "Actions" tab in the GitHub repository
2. Select the "Release dev container features & Generate Documentation" workflow
3. Click "Run workflow"

This will publish the feature to GitHub Container Registry and update the documentation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
# <p align="center">Sei 精</p>

<p align="center">
  <img src="./logo/logo.jpg" width=400>
</p>

Sei is a minimal Neovim configuration focused on Go development.

The goal is to provide a clean, practical development environment without unnecessary complexity. The configuration is designed to be easy to understand, maintain, and modify.

## Meaning

精 (sei) is a Japanese kanji with meanings that include essence, 精, as in spirit, refinement, or precision, depending on context.

It represents the idea behind this configuration: keeping things focused on what matters, removing unnecessary complexity, and refining the development experience without making it cumbersome.

## Features

- Minimal Neovim configuration focused on Go.
- A clean and practical development environment.
- A setup script for Ubuntu and Debian.
- Readable, documented configuration intended to be easily modified.

## Requirements

- Ubuntu or Debian.
- sudo privileges for installing system dependencies.
- Git and curl.
- Neovim and Go, installed by the setup script if needed.

## Installation

Clone the repository:

```bash
git clone https://github.com/TynK-M/sei.git
cd sei
```

Run the setup script as your normal user, not as root:

```bash
./setup.sh
```

The script is intended for Ubuntu and Debian-based systems. Review it before running if you want to understand or modify the installation process.

## Version selection

The setup script supports the SEI_VERSION variable:

- **Empty**, use the latest version from the main branch.
- **Set to a version tag**, use the corresponding tagged release.

For example, to install a specific tagged version:

```bash
SEI_VERSION="v1.0.0" ./setup.sh
```

Replace `v1.0.0` with an actual tag available in the repository.

## Configuration

Neovim configuration files are installed under:

```bash
~/.config/nvim
```

The setup script is designed to preserve an existing configuration by creating a backup before replacing it.

## Philosophy

Sei aims to be small, understandable, and adaptable. It is not intended to be a feature-heavy distribution of Neovim, but a starting point for a focused Go development environment that you can make your own.

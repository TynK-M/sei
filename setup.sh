#!/usr/bin/env bash

# TynK-M | Sei 精
# Sei is a minimal Neovim setup to work with Go-lang.
#
# Neovim configuration setup.
# Run as normal user, NOT as root.
#
# Supported operating systems:
# - Ubuntu
# - Debian
#
# This script installs the tools required by Sei, fetches the requested
# version of the repository, backs up the existing Neovim configuration,
# installs the new configuration, and synchronizes its plugins.
#
# It is deliberately documented in detail so that it can be understood,
# modified, and maintained without requiring knowledge of every Bash feature.
#
# IMPORTANT:
# - Review the script before executing it.
# - A working internet connection is required.
# - sudo is used to install system packages.
# - Do not run this script as root.

# Refer to `man bash`.
#
# Enable strict shell behaviour.
#
# -E (errtrace):
#   Makes ERR traps inherited by shell functions, command substitutions,
#   and subshell environments where applicable.
#
# -e (errexit):
#   Stops execution when a command fails in a context where errexit applies.
#   This helps prevent later installation steps from running after a failure.
#
# -u (nounset):
#   Treats an unset variable as an error instead of silently expanding it
#   to an empty string.
#
# -o pipefail:
#   Makes a pipeline fail if a command within the pipeline fails, rather
#   than reporting only the exit status of the last command.
#
# These options improve reliability, but they do not replace explicit
# checks for important conditions.
set -Eeuo pipefail

# ---------------------------------------------------------------------------
# Sei ASCII banner
# ---------------------------------------------------------------------------

# Display the Sei ASCII art at the beginning of the setup process.
#
# The banner uses a custom off-white color: #F6F8ED.
#
# This color choice is inspired by the appearance of white rice, connecting
# the visual identity of Sei to the Japanese kanji used in the project:
#
#   精 (sei)
#
# The kanji 精 contains the radical 米, meaning rice, and is associated with
# the process of polishing rice to make it white. Its meanings also extend to
# purity, refinement, precision, and spirit.
#
# These associations reflect the philosophy behind Sei: a minimal, carefully
# refined Neovim configuration designed to provide a clean and focused
# development environment.
#
# #F6F8ED is a custom rice-inspired off-white rather than an official color
# standard for white rice. Its subtle green undertone gives it more character
# than pure white (#FFFFFF) while keeping the overall appearance restrained.
#
# RGB values:
#   Red:   246
#   Green: 248
#   Blue:  237
#
# ANSI 24-bit foreground color:
#   \033[38;2;246;248;237m
#
# `printf` is used to enable the color before printing the banner.
#
# The quoted here-document delimiter ('EOF') prevents Bash from interpreting
# variables, command substitutions, or escape sequences inside the ASCII art.
#
# After the banner, the terminal formatting is reset so that subsequent
# installation messages can use their own colors.

printf '\033[38;2;246;248;237m'

cat <<'EOF'
+################################################################
##-............................................................+#
##-................................-++--.......................+#
##.................-++-.............+####-.....................+#
##..................+###+...........-###+......................+#
##-.................-###-..-........-###+-+####-...............+#
##-..................###-.-##+---+++#######+++-................+#
##-...........---....###-.+###--++++-###-.--...................+#
##-............+##+-.###-+##-......--########+-................+#
##-.............+##-.###+#-.....-#######+--....---.............+#
##-..............--..###+###+-......-+##--++########+..........+#
##-.............--+########+--.-++###########++++++##-.........+#
##-.......-+#######+###+...+#####++--....---...................+#
##-..........-+--..+####+-......-----++######+-................+#
##-...............+#########-...-###++---.-####-...............+#
##-..............+##+##+.+###-..-###.----..###+................+#
##-............-+##-.##+..-++-...#######+-.+##+................+#
##-...........-###-..##+........-##+...--..-##+-...............+#
##-..........+##-....##+-.......-#########-.###-...............+#
##-........+#+-.....-###-.......+##+........###-...............+#
##-................-+##+-......-+##+........###-...............+#
##-................-###+.......-###+...-+---###+...............+#
##-.................+##+........+##-....-######+...............+#
##-..................-+-.........+-.......+###+-...............+#
##-........................................+#-.................+#
##-............................................................+#
#################################################################
EOF

# Reset the terminal color and leave a blank line before the installation
# logs.
printf '\033[0m\n'

# ---------------------------------------------------------------------------
# Configuration constants
# ---------------------------------------------------------------------------

# URL of the official Sei repository.
#
# The script clones this repository to obtain the Neovim configuration.
# Change this constant if the repository is moved or renamed (or to point a
# fork).
REPO_URL="https://github.com/TynK-M/sei.git"

# Version of Sei to setup.
#
# Supported values:
#
#   SEI_VERSION=""
#       Fetch the latest commit from the remote main branch.
#
#   SEI_VERSION="v1.0.0"
#       Fetch the Git tag named `v1.0.0`.
#
#   SEI_VERSION="1.0.0"
#       First check `v1.0.0`, then check `1.0.0` if the first tag is missing.
#
# An empty value follows the moving main branch. A version tag is preferable
# when you want a reproducible setup tied to a specific release.
#
# The tag must exist on the remote repository.
SEI_VERSION=""

# Name of the configuration directory created under XDG_CONFIG_HOME.
#
# This value is used when constructing CONFIG_DIR.
#
# Example:
#   CONFIG_NAME="nvim"
#
# Results in:
#   ~/.config/nvim
#
# when XDG_CONFIG_HOME is not set.
#
# Changing this value changes the directory where the Sei configuration
# files are installed.
CONFIG_NAME="nvim"

# Default configuration directory for Neovim.
#
# XDG_CONFIG_HOME is the standard environment variable for user configuration
# files. If it is not set, use ~/.config.
#
# The resulting default path is:
#   ~/.config/nvim
#
# This is where Neovim looks for init.lua and the lua/ configuration
# directory.
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/${CONFIG_NAME}"

# Directory for user-installed executables.
#
# Programs installed here do not require administrator privileges.
# The directory is added to PATH later in this script.
#
# Examples:
#   ~/.local/bin/nvim
#   ~/.local/bin/go
#   ~/.local/bin/gopls
LOCAL_BIN="$HOME/.local/bin"

# Directory for locally installed software.
#
# Software installed here belongs to the current user and does not replace
# the operating system's package-managed files.
#
# Examples:
#   ~/.local/opt/nvim
#   ~/.local/opt/go
LOCAL_OPT="$HOME/.local/opt"

# Timestamp used to distinguish configuration backups.
#
# The date command produces a string such as:
#   20261027-201800
#
# Including the timestamp in a backup name helps avoid overwriting a backup
# created by an earlier run.
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

# Temporary directory used while setting up.
#
# This starts empty because mktemp creates a unique directory later.
# A unique directory avoids collisions with other running processes and
# prevents the script from accidentally deleting a user's existing directory.
TMP_DIR=""

# Backup directory for the previous Neovim configuration.
#
# This also starts empty. It is assigned a value only if an existing
# configuration needs to be backed up.
BACKUP_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim_old"

# Flag indicating whether the new configuration has been installed.
#
# 0 means that the new configuration has not been installed or is considered
# successful.
#
# 1 means that configuration files have been replaced and a later failure
# should trigger an attempt to restore the backup.
#
# Bash arithmetic and integer comparisons interpret 0 as false and 1 as true
# by convention; these are ordinary integer values, not Boolean types.
CONFIG_INSTALLED=0

# ---------------------------------------------------------------------------
# Logging functions
# ---------------------------------------------------------------------------

# Print an informational message.
#
# "$*" combines all function arguments into a single message.
# printf is used instead of echo because printf provides predictable
# formatting.
#
# ANSI escape sequences:
#   \033[1;32m  Bold green text
#   \033[0m      Reset text formatting
#
# Example:
#   log "Installing system dependencies..."
log() {
    printf '\033[1;32m[sei] INFO:\033[0m %s\n' "$*"
}

# Print a warning message to standard error.
#
# Warnings indicate a problem that may not require immediate termination.
# Standard error keeps warnings separate from ordinary command output.
#
# ANSI escape sequences:
#   \033[1;33m  Bold yellow text
warn() {
    printf '\033[1;33m[sei] WARN:\033[0m %s\n' "$*" >&2
}

# Print an error message and terminate the script.
#
# exit 1 returns a nonzero exit status to the calling shell, indicating
# failure.
#
# This function is used when continuing would be unsafe or meaningless.
die() {
    printf '\033[1;31m[sei] ERROR:\033[0m %s\n' "$*" >&2
    exit 1
}

# ---------------------------------------------------------------------------
# Cleanup and failure recovery
# ---------------------------------------------------------------------------

# Remove temporary files when the script exits.
#
# The EXIT trap calls this function on both successful and unsuccessful exits.
#
# The function also attempts to restore the previous Neovim configuration if:
# - The new configuration was installed.
# - A later operation failed.
#
# This recovery is best-effort. It cannot guarantee restoration after every
# possible failure, such as a sudden power loss or filesystem failure.
cleanup() {
    # Save the original exit status before running any cleanup commands.
    # $? is the exit status of the command that ran immediately before this
    # function was entered.
    local status=$?

    # Restore the previous configuration only after a failed installation
    # that had already begun replacing the configuration directory.
    if [[ "$status" -ne 0 && "$CONFIG_INSTALLED" -eq 1 ]]; then
        warn "Setup failed. Attempting to restore the previous config."

        # Remove the incomplete new configuration.
        #
        # -- prevents a path beginning with a hyphen from being interpreted
        # as a command-line option.
        rm -rf -- "$CONFIG_DIR"

        # Restore the backup only when a backup path was assigned and the
        # directory still exists.
        if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
            mv -- "$BACKUP_DIR" "$CONFIG_DIR"
            log "Previous configuration restored."
        fi
    fi

    # Remove the temporary directory if it was created and still exists.
    #
    # This removes the temporary clone and any downloaded archives stored
    # inside that directory.
    if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then
        rm -rf -- "$TMP_DIR"
    fi
}

# Register cleanup to run when the script exits.
#
# The EXIT trap helps ensure temporary files are removed even when a command
# fails under set -e.
trap cleanup EXIT

# ---------------------------------------------------------------------------
# Prerequisite checks
# ---------------------------------------------------------------------------

# Ensure the script is not being executed as root.
#
# EUID is Bash's effective user ID.
# The root account has an effective user ID of 0.
#
# Running as a normal user allows configuration files and local software
# to be installed with the correct ownership.
#
# sudo is used separately for system package installation.
[[ "$EUID" -ne 0 ]] ||
    die "Run this script as your normal user, not root."

# Ensure sudo is available.
#
# command -v checks whether the named executable can be found.
# Redirecting output to /dev/null suppresses the executable path.
command -v sudo >/dev/null 2>&1 ||
    die "sudo is required."

# Ensure apt-get is available.
#
# apt-get is the package manager used by Debian and Ubuntu.
# This script does not currently support Fedora, Arch Linux, or macOS.
command -v apt-get >/dev/null 2>&1 ||
    die "This script supports Ubuntu/Debian only."

# Ensure Git is available before checking the remote repository.
#
# Git is needed to query remote branches and tags, and later to clone Sei.
command -v git >/dev/null 2>&1 ||
    die "git must be available to check the repository."

# ---------------------------------------------------------------------------
# Architecture detection
# ---------------------------------------------------------------------------

# Detect the Debian package architecture.
#
# dpkg --print-architecture returns values such as:
#   amd64
#   arm64
#
# The architecture determines which Neovim and Go archives must be downloaded.
ARCH="$(dpkg --print-architecture)"

# Map Debian architecture names to the names used by the upstream downloads.
#
# The case statement allows explicit support for each architecture.
# Unsupported architectures stop the script rather than downloading an
# incompatible executable.
case "$ARCH" in
amd64)
    NVIM_ARCH="x86_64"
    GO_ARCH="amd64"
    ;;
arm64)
    NVIM_ARCH="arm64"
    GO_ARCH="arm64"
    ;;
*)
    die "Unsupported architecture: $ARCH"
    ;;
esac

# Create local installation directories.
#
# mkdir -p:
# - Creates missing parent directories.
# - Does not fail simply because a directory already exists.
#
# These paths are under the current user's home directory.
mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"

# ---------------------------------------------------------------------------
# Sei version selection
# ---------------------------------------------------------------------------

# Decide which remote Git reference should be used.
#
# A Git reference may be:
# - A branch, such as main.
# - A tag, such as v1.0.0.
#
# Branches can move as new commits are pushed. Version tags are intended to
# identify particular releases or commits.
if [[ -z "$SEI_VERSION" ]]; then

    # An empty version means that the user wants the latest main branch.
    SEI_REF="main"

    log "No Sei version specified; using the latest main branch."

else

    # Normalize the supplied version.
    #
    # If the value already begins with "v", preserve it.
    # Otherwise, prepend "v".
    #
    # This supports both:
    #   v1.0.0
    #   1.0.0
    if [[ "$SEI_VERSION" == v* ]]; then
        SEI_REF="$SEI_VERSION"
    else
        SEI_REF="v${SEI_VERSION}"
    fi

    log "Requested Sei version: $SEI_REF"
fi

# ---------------------------------------------------------------------------
# Remote repository validation
# ---------------------------------------------------------------------------

# Check that the selected branch or tag exists before downloading software.
#
# git ls-remote queries references advertised by the remote repository.
# It does not need to create a complete local clone.
#
# The resulting commit hash is stored so that the script can verify that
# the later clone fetched the expected commit.
log "Checking the Sei repository..."

# Query the remote main branch when no version was specified.
if [[ "$SEI_REF" == "main" ]]; then

    # refs/heads/main identifies the main branch.
    #
    # awk prints only the first whitespace-separated field, which is the
    # commit hash returned by Git.
    REMOTE_COMMIT="$(
        git ls-remote "$REPO_URL" refs/heads/main |
            awk 'NR == 1 { print $1 }'
    )"

else

    # First look for the exact normalized version tag.
    #
    # --refs asks Git to report matching references directly rather than
    # including additional peeled-tag entries.
    REMOTE_COMMIT="$(
        git ls-remote --refs "$REPO_URL" "refs/tags/${SEI_REF}" |
            awk 'NR == 1 { print $1 }'
    )"

    # If the normalized tag does not exist, try the version without "v".
    #
    # For example:
    #   First attempt: refs/tags/v1.0.0
    #   Second attempt: refs/tags/1.0.0
    #
    # This is useful for repositories that use tags without a leading "v".
    if [[ -z "$REMOTE_COMMIT" ]]; then

        # Remove the leading "v", if present.
        ALT_REF="${SEI_REF#v}"

        REMOTE_COMMIT="$(
            git ls-remote --refs "$REPO_URL" "refs/tags/${ALT_REF}" |
                awk 'NR == 1 { print $1 }'
        )"

        # If the alternative tag exists, remember its actual name so that
        # git clone checks out the correct reference.
        if [[ -n "$REMOTE_COMMIT" ]]; then
            SEI_REF="$ALT_REF"
        fi
    fi
fi

# Stop if the selected branch or tag could not be found.
#
# This can happen because:
# - The version does not exist.
# - The branch was renamed or removed.
# - The repository is unavailable.
# - The network connection failed.
#
# A Git network failure and a nonexistent reference can both result in an
# empty value here, so the message deliberately does not claim which occurred.
[[ -n "$REMOTE_COMMIT" ]] ||
    die "Could not find '$SEI_REF' on the remote repository. Check the version or connection."

# Display the selected reference and commit for troubleshooting.
log "Selected ref: $SEI_REF"
log "Remote commit: $REMOTE_COMMIT"

# ---------------------------------------------------------------------------
# System package installation
# ---------------------------------------------------------------------------

# Refresh the local package index.
#
# apt-get update downloads the latest package metadata from the configured
# Ubuntu/Debian repositories.
#
# sudo elevates this operation because package metadata is managed by the
# operating system.
log "Updating package lists..."
sudo apt-get update

# Install required system packages.
#
# DEBIAN_FRONTEND=noninteractive prevents package installation from prompting
# for interactive configuration input.
#
# Package descriptions:
#
# ca-certificates:
#   Trusted certificate authorities used for HTTPS connections.
#
# curl:
#   Downloads archives and retrieves information from HTTPS endpoints.
#
# git:
#   Fetches the Sei repository and checks remote references.
#
# build-essential, make, gcc, g++:
#   Compiler and build tools used by native dependencies.
#
# pkg-config:
#   Helps build systems locate installed native libraries.
#
# unzip, tar, gzip:
#   Extract downloaded archives.
#
# xclip:
#   Provides X11 clipboard integration for Neovim.
#
# ripgrep:
#   Fast text-search utility commonly used by Telescope.
#
# fd-find:
#   Fast file-search utility available under the Debian/Ubuntu name fdfind.
#
# Some packages may already be installed. apt-get will leave current
# installations in place when they satisfy the package requirements.
log "Installing system dependencies..."

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates \
    curl \
    git \
    build-essential \
    make \
    gcc \
    g++ \
    pkg-config \
    unzip \
    tar \
    gzip \
    xclip \
    ripgrep \
    fd-find

# ---------------------------------------------------------------------------
# Neovim installation
# ---------------------------------------------------------------------------

# Determine whether a sufficiently recent Neovim is already available.
#
# This configuration uses modern Neovim LSP APIs and therefore requires
# Neovim 0.11 or newer.
#
# NVIM_BIN records the executable that will be used for the rest of setup.
# It may point to an existing system installation or a local installation.
NVIM_BIN=""

# Check the Neovim executable found through PATH.
if command -v nvim >/dev/null 2>&1; then

    # Capture the first line of Neovim's version output.
    CURRENT_NVIM="$(nvim --version | head -n 1)"

    # Accept version 0.11 or later within major version 0.
    #
    # This is a simple version pattern, not a general semantic-version parser.
    if printf '%s\n' "$CURRENT_NVIM" |
        grep -Eq 'NVIM v0\.(1[1-9]|[2-9][0-9])'; then

        NVIM_BIN="$(command -v nvim)"
        log "Compatible Neovim found: $CURRENT_NVIM"
    fi
fi

# Download Neovim if no compatible installation was found.
if [[ -z "$NVIM_BIN" ]]; then

    log "Installing the latest Neovim release..."

    # Create a unique temporary directory for the downloaded archive.
    TMP_DIR="$(mktemp -d)"

    # Build the archive filename from the detected architecture.
    #
    # Example:
    #   nvim-linux-x86_64.tar.gz
    NVIM_ARCHIVE="nvim-linux-${NVIM_ARCH}.tar.gz"

    # Download the official latest-release archive.
    #
    # --fail:
    #   Return an error for HTTP error responses.
    #
    # --location:
    #   Follow HTTP redirects.
    #
    # --retry 3:
    #   Retry some transient download failures up to three times.
    #
    # --output:
    #   Write the archive to the temporary directory.
    curl --fail --location --retry 3 \
        "https://github.com/neovim/neovim/releases/latest/download/${NVIM_ARCHIVE}" \
        --output "$TMP_DIR/$NVIM_ARCHIVE"

    # Extract the archive into the local software directory.
    tar -xzf "$TMP_DIR/$NVIM_ARCHIVE" -C "$LOCAL_OPT"

    # Determine the expected extracted directory.
    EXTRACTED_DIR="$LOCAL_OPT/nvim-linux-${NVIM_ARCH}"

    # Verify that the expected executable exists before moving anything.
    [[ -x "$EXTRACTED_DIR/bin/nvim" ]] ||
        die "Neovim archive does not contain the expected executable."

    # Replace the previous manually managed Neovim installation, if present.
    #
    # This affects only ~/.local/opt/nvim, not an apt-managed system version.
    rm -rf "$LOCAL_OPT/nvim"

    # Give the extracted installation a stable directory name.
    mv "$EXTRACTED_DIR" "$LOCAL_OPT/nvim"

    # Remember the executable's absolute path.
    NVIM_BIN="$LOCAL_OPT/nvim/bin/nvim"

    # Remove the downloaded archive and temporary directory.
    rm -rf "$TMP_DIR"
    TMP_DIR=""
fi

# ---------------------------------------------------------------------------
# Neovim PATH setup
# ---------------------------------------------------------------------------

# Create a stable command path for Neovim.
#
# A symbolic link means users can run "nvim" without knowing the exact
# installation directory.
#
# ln -sfn:
# - -s creates a symbolic link.
# - -f replaces an existing destination link.
# - -n prevents treating an existing destination symlink as a directory.
#
# If Neovim was already available at ~/.local/bin/nvim, no link is needed.
if [[ "$NVIM_BIN" != "$LOCAL_BIN/nvim" ]]; then
    ln -sfn "$NVIM_BIN" "$LOCAL_BIN/nvim"
fi

# ---------------------------------------------------------------------------
# Go installation
# ---------------------------------------------------------------------------

# Retrieve the current stable Go version.
#
# The official endpoint returns a version string such as:
#   go1.25.0
#
# The exact version changes as new Go releases are published.
log "Checking the latest Go release..."

GO_VERSION="$(
    curl --fail --silent --show-error \
        'https://go.dev/VERSION?m=text' |
        head -n 1
)"

# Validate the returned version before constructing a download URL.
#
# This accepts standard Go version strings such as:
#   go1.25
#   go1.25.0
#
# It rejects unexpected text or an empty result.
[[ "$GO_VERSION" =~ ^go[0-9]+\.[0-9]+(\.[0-9]+)?$ ]] ||
    die "Could not determine a valid Go version."

# Reuse the locally installed Go version if it matches the version endpoint.
#
# Otherwise, download and replace the manually managed installation.
#
# This installation is separate from any Go version installed using apt.
if [[ -x "$LOCAL_OPT/go/bin/go" ]] &&
    "$LOCAL_OPT/go/bin/go" version | grep -Fq "$GO_VERSION"; then

    log "$GO_VERSION is already installed."

else

    log "Installing $GO_VERSION..."

    # Create a temporary directory for the Go archive.
    TMP_DIR="$(mktemp -d)"

    # Construct the archive name from the selected version and architecture.
    #
    # Example:
    #   go1.25.0.linux-amd64.tar.gz
    GO_ARCHIVE="${GO_VERSION}.linux-${GO_ARCH}.tar.gz"

    # Download the archive from the official Go downloads host.
    curl --fail --location --retry 3 \
        "https://go.dev/dl/${GO_ARCHIVE}" \
        --output "$TMP_DIR/$GO_ARCHIVE"

    # Replace the existing manually managed Go installation.
    #
    # This does not remove an apt-managed installation elsewhere on the system.
    rm -rf "$LOCAL_OPT/go"

    # The official archive extracts into a directory named "go".
    tar -xzf "$TMP_DIR/$GO_ARCHIVE" -C "$LOCAL_OPT"

    # Remove the temporary download after successful extraction.
    rm -rf "$TMP_DIR"
    TMP_DIR=""
fi

# Create a stable command path for Go.
#
# This allows the user to run "go" from ~/.local/bin once that directory
# has been added to PATH.
ln -sfn "$LOCAL_OPT/go/bin/go" "$LOCAL_BIN/go"

# ---------------------------------------------------------------------------
# Persistent PATH configuration
# ---------------------------------------------------------------------------

# Add local executables and Go's binary directory to PATH.
#
# PATH is the colon-separated list of directories searched by the shell when
# resolving commands such as nvim, go, and gopls.
#
# ~/.profile:
#   Commonly read for login sessions.
#
# ~/.bashrc:
#   Commonly read by interactive Bash shells.
#
# The exact startup files read depend on the terminal and login configuration.
#
# grep -Fqx checks for an exact literal line. This avoids appending the same
# PATH declaration repeatedly when the script is run more than once.
PATH_LINE='export PATH="$HOME/.local/bin:$HOME/.local/opt/go/bin:$PATH"'

for RC_FILE in "$HOME/.profile" "$HOME/.bashrc"; do

    # Create the file if it does not already exist.
    touch "$RC_FILE"

    # Append the PATH declaration only when it is not already present.
    if ! grep -Fqx "$PATH_LINE" "$RC_FILE"; then
        printf '\n# Added by Sei setup\n%s\n' "$PATH_LINE" \
            >>"$RC_FILE"
    fi
done

# Update PATH for the current script process.
#
# Editing ~/.profile or ~/.bashrc does not automatically change the
# environment of a shell that is already running.
export PATH="$LOCAL_BIN:$LOCAL_OPT/go/bin:$PATH"

# ---------------------------------------------------------------------------
# Go language server
# ---------------------------------------------------------------------------

# Install gopls, the official Go language server.
#
# Neovim's LSP configuration uses a language server to provide features such as:
# - Diagnostics and error reporting.
# - Go-to-definition.
# - Find references.
# - Symbol navigation.
# - Rename support.
#
# go install downloads and builds the specified Go package.
#
# GOBIN directs the resulting executable to ~/.local/bin.
#
# @latest selects the latest version of this Go module. This is independent
# of SEI_VERSION; the Sei configuration tag does not pin gopls.
log "Installing gopls..."

GOBIN="$LOCAL_BIN" go install golang.org/x/tools/gopls@latest

# ---------------------------------------------------------------------------
# fd command compatibility
# ---------------------------------------------------------------------------

# Debian and Ubuntu commonly package fd under the executable name "fdfind".
#
# Some tools and configurations expect the executable to be named "fd".
#
# If fdfind exists and fd does not, create a symbolic link in ~/.local/bin.
#
# command -v returns the path of the executable found in PATH.
#
# This step does not replace an existing fd command.
if command -v fdfind >/dev/null 2>&1 &&
    ! command -v fd >/dev/null 2>&1; then

    ln -sfn "$(command -v fdfind)" "$LOCAL_BIN/fd"
fi

# ---------------------------------------------------------------------------
# Fetch the requested Sei version
# ---------------------------------------------------------------------------

# Clone the selected branch or tag into a temporary directory.
#
# --depth 1:
#   Creates a shallow clone containing the selected commit's immediate history.
#   This is faster and downloads less data than cloning the full history.
#
# --branch:
#   Selects a branch or tag by name.
#
# The clone is temporary because the script only needs the repository files
# that make up the Neovim configuration.
log "Fetching Sei ($SEI_REF)..."

TMP_DIR="$(mktemp -d)"

git clone \
    --depth 1 \
    --branch "$SEI_REF" \
    "$REPO_URL" \
    "$TMP_DIR/sei"

# Store the path to the checked-out repository.
REPO_DIR="$TMP_DIR/sei"

# ---------------------------------------------------------------------------
# Validate the fetched repository
# ---------------------------------------------------------------------------

# Determine the actual commit checked out by Git.
#
# rev-parse HEAD returns the full commit hash of the current checkout.
LOCAL_COMMIT="$(git -C "$REPO_DIR" rev-parse HEAD)"

# Compare the fetched commit with the commit discovered by ls-remote.
#
# This check helps detect a branch or tag that moved between the initial
# remote query and the clone.
#
# If the branch changed during that interval, the script stops rather than
# silently claiming it installed the previously observed commit.
if [[ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]]; then
    die "The fetched commit differs from the remote ref. Please retry."
fi

log "Fetched commit: $LOCAL_COMMIT"

# Verify that the repository has the expected Neovim configuration files.
#
# init.lua is the main Neovim configuration entry point.
#
# The lua/ directory contains additional Lua modules used by the configuration.
#
# Stop if these expected paths are missing. This prevents copying an unrelated
# or incomplete repository into the user's Neovim configuration directory.
[[ -f "$REPO_DIR/init.lua" ]] ||
    die "The repository is missing init.lua."

[[ -d "$REPO_DIR/lua" ]] ||
    die "The repository is missing the lua/ directory."

# ---------------------------------------------------------------------------
# Back up the existing Neovim configuration
# ---------------------------------------------------------------------------

# Preserve the existing configuration before installing the new one.
#
# The backup is created only if CONFIG_DIR already exists.
#
# The backup path contains the timestamp created near the beginning of this
# script, for example:
#
#   ~/.config/nvim.backup-20261027-201800
#
# mv moves the entire configuration directory, preserving its files and
# subdirectories rather than deleting them.
#
# This also preserves files that are not tracked by the Sei repository.
if [[ -e "$CONFIG_DIR" || -L "$CONFIG_DIR" ]]; then

    BACKUP_DIR="${CONFIG_DIR}.backup-${TIMESTAMP}"

    log "Backing up existing configuration to:"
    log "$BACKUP_DIR"

    mv -- "$CONFIG_DIR" "$BACKUP_DIR"
fi

# ---------------------------------------------------------------------------
# Install the Sei configuration files
# ---------------------------------------------------------------------------

# Create the configuration directory.
#
# This is necessary when:
# - No previous Neovim configuration existed.
# - The previous configuration was moved to the backup path.
mkdir -p "$CONFIG_DIR"

# Mark the configuration as installed before copying files.
#
# If a later copy or plugin setup operation fails, cleanup will attempt to
# remove the incomplete configuration and restore the previous backup.
CONFIG_INSTALLED=1

# Copy the main Neovim configuration file.
#
# init.lua is loaded by Neovim during startup.
cp -a "$REPO_DIR/init.lua" "$CONFIG_DIR/"

# Copy all Lua modules.
#
# These files may contain the plugin declarations, key mappings, options,
# theme configuration, and language-server settings.
#
# -a preserves the directory structure and file metadata.
cp -a "$REPO_DIR/lua" "$CONFIG_DIR/"

# Copy the plugin lockfile if the repository provides one.
#
# lazy-lock.json records plugin versions managed by lazy.nvim.
#
# Keeping the lockfile allows plugin synchronization to use the versions
# recorded by the repository, where those versions remain available.
#
# The conditional makes this step optional for repository versions that
# do not include a lockfile.
if [[ -f "$REPO_DIR/lazy-lock.json" ]]; then
    cp -a "$REPO_DIR/lazy-lock.json" "$CONFIG_DIR/"
fi

# ---------------------------------------------------------------------------
# Synchronize Neovim plugins
# ---------------------------------------------------------------------------

# Ensure locally installed tools are available during Neovim startup.
export PATH="$LOCAL_BIN:$LOCAL_OPT/go/bin:$PATH"

# Run Neovim without opening its graphical or interactive interface.
#
# --headless:
#   Starts Neovim without an interactive terminal UI.
#
# +Lazy! sync:
#   Asks lazy.nvim to synchronize plugins. This can install missing plugins
#   and update the plugin installation to match the configured lockfile.
#
# +qa:
#   Quits all Neovim windows after the synchronization command completes.
#
# Plugin setup can fail because of network errors, missing build tools,
# incompatible plugins, or errors in the configuration.
#
# Since strict shell behavior is enabled, an unsuccessful Neovim invocation
# causes the script to exit and invokes the cleanup handler.
log "Synchronizing Neovim plugins. This may take a few minutes..."

NVIM_APPNAME=${CONFIG_NAME} \
    "$NVIM_BIN" --headless "+Lazy! sync" +qa

# ---------------------------------------------------------------------------
# Verify the installation
# ---------------------------------------------------------------------------

# Display the installed Neovim version.
#
# This is useful for confirming that a compatible executable is being used.
log "Verifying the setup..."

"$NVIM_BIN" --version | head -n 1

# Display the installed Go version.
#
# This checks that the go command is accessible and functioning.
go version

# Ask gopls to display its version.
#
# A failure here is reported as a warning rather than a fatal installation
# error because the remaining configuration may still be usable.
if ! gopls version; then
    warn "Could not verify gopls. Check the Go installation."
fi

# ---------------------------------------------------------------------------
# Mark setup as successful
# ---------------------------------------------------------------------------

# Set the recovery flag to zero.
#
# The configuration and plugin synchronization steps have completed.
# The cleanup handler must no longer treat a later normal exit as a failed
# configuration installation.
CONFIG_INSTALLED=0

# Print the installation summary.
log "Sei setup completed successfully."

printf '\n'
printf 'Sei ref:    %s\n' "$SEI_REF"
printf 'Commit:     %s\n' "$LOCAL_COMMIT"
printf 'Config:     %s\n' "$CONFIG_DIR"
printf '\n'

# Display the location of the backup if one was created.
#
# The backup is intentionally retained so the user can manually recover
# previous settings or copy custom files into the new configuration.
if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
    printf 'Previous config backup:\n  %s\n\n' "$BACKUP_DIR"
fi

# Print basic usage instructions.
#
# The shortcuts below are examples; their availability depends on the
# mappings defined by the selected Sei version.
cat <<'EOF'
Launch Neovim with:

    nvim

If nvim or go is not found in the current terminal, open a new
terminal or run:

    source ~/.profile

Useful shortcuts (leader is Space):

    Space ff    Find files
    Space fg    Search file contents
    Space fb    Find buffers
    gd          Go to definition
    gr          Find references
    K           Show documentation
    Space rn    Rename symbol

Notes:
- Go language-server support uses gopls.
- The plugin lockfile is copied when provided by the repository.
- Existing configuration backups are retained.
- This script does not configure project-specific environment variables.
- Review the repository README for any additional requirements.

EOF

# End of setup.sh.
#
# The EXIT trap runs cleanup one last time. Because CONFIG_INSTALLED is zero,
# a successful run does not remove the newly installed configuration.

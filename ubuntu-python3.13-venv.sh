#!/bin/bash

# Exit on error
set -e

# Check if a path argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_venv>"
  exit 1
fi

# Path to the virtual environment
VENV_PATH=$1

echo "Updating package list..."
sudo apt update -qq

echo "Installing software-properties-common..."
sudo apt install -y -qq software-properties-common

echo "Adding deadsnakes PPA..."
sudo add-apt-repository -y ppa:deadsnakes/ppa > /dev/null

echo "Updating package list again..."
sudo apt update -qq

echo "Creating virtual environment at $VENV_PATH..."
python3.13 -m venv "$VENV_PATH/venv" --without-pip

echo "Activating virtual environment..."
source "$VENV_PATH/venv/bin/activate"

echo "Downloading get-pip.py..."
curl -s -O https://bootstrap.pypa.io/get-pip.py

echo "Installing pip..."
python get-pip.py > /dev/null

echo "Cleaning up get-pip.py..."
rm get-pip.py

echo "Verifying pip installation..."
pip --version

echo "Virtual environment setup complete at $VENV_PATH."

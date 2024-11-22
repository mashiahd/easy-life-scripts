#!/bin/bash

# Exit on error
set -e

# Check if a path argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_venv> (the dir to create venv in)"
  exit 1
fi

# Path to the virtual environment
VENV_PATH=$1

# Function to check if Python 3.13 is installed
function check_python_version {
  if python3.13 --version &> /dev/null; then
    echo "Python 3.13 is already installed."
    return 0
  else
    echo "Python 3.13 is not installed."
    return 1
  fi
}

# Check if Python 3.13 is installed
if ! check_python_version; then
  echo "Updating package list..."
  sudo apt update -qq

  echo "Installing software-properties-common..."
  sudo apt install -y -qq software-properties-common

  echo "Adding deadsnakes PPA..."
  sudo add-apt-repository -y ppa:deadsnakes/ppa > /dev/null

  echo "Updating package list again..."
  sudo apt update -qq

  echo "Installing Python 3.13..."
  sudo apt install -y -qq python3.13
fi

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

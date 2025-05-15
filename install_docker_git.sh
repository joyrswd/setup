#!/bin/bash

set -e

echo "=== Updating system ==="
sudo apt update
sudo apt upgrade -y

echo "=== Installing dependencies ==="
sudo apt install -y \
    build-essential \
    wget curl git vim unzip zip htop \
    ca-certificates gnupg software-properties-common libsecret-1-0 gnome-keyring \
    lsb-release \
    git

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
    echo "SSH key created at ~/.ssh/id_ed25519"
else
    echo "SSH key already exists at ~/.ssh/id_ed25519 — skipping generation."
fi

echo "=== Adding Docker's official GPG key ==="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "=== Setting up Docker repository ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Installing Docker Engine ==="
sudo apt update
sudo apt install -y docker-ce

echo "=== Adding current user to docker group ==="
sudo usermod -aG docker $USER
echo "Please log out and log back in to apply group changes."

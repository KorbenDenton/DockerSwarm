#!/bin/bash

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant

if [[ $(hostname) == "manager01" ]]; then
  docker swarm init --advertise-addr 192.168.33.10
  docker swarm join-token -q worker > /vagrant/worker_token
fi
SWARM_TOKEN=$(cat /vagrant/worker_token)
if [[ $(hostname) == "worker01" ]]; then
  docker swarm join --token $SWARM_TOKEN 192.168.33.10:2377
fi
if [[ $(hostname) == "worker02" ]]; then
  docker swarm join --token $SWARM_TOKEN 192.168.33.10:2377
fi

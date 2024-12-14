#!/bin/bash

# This script will be run through Jenkins job to set up Ansible on the same server where Jenkins is running

# Update PATH for Jenkins
export PATH=$PATH:/usr/bin:/usr/local/bin

# Variables
JENKINS_HOME="/var/lib/jenkins"
ANSIBLE_DIR="$JENKINS_HOME/.ansible"
INVENTORY_FILE="$ANSIBLE_DIR/hosts"
ANSIBLE_CFG="$ANSIBLE_DIR/ansible.cfg"
SSH_DIR="$JENKINS_HOME/.ssh"
PRIVATE_KEY="$SSH_DIR/id_rsa"
KNOWN_HOSTS="$SSH_DIR/known_hosts"
REMOTE_HOST="34.45.70.74"

# Update package list and install Ansible
sudo apt update
sudo apt install -y ansible

# Verify Ansible installation
ansible --version || { echo "Ansible installation failed"; exit 1; }

# Ensure the configuration directory and SSH directory exist
sudo mkdir -p $ANSIBLE_DIR
sudo mkdir -p $SSH_DIR

# Create and configure ansible.cfg
echo "[defaults]
inventory = $INVENTORY_FILE
timeout = 30
private_key_file = $PRIVATE_KEY
" | sudo tee "$ANSIBLE_CFG"

# Create the inventory file
echo "[servers]
test ansible_host=$REMOTE_HOST ansible_user=ad_zabbix63 ansible_connection=ssh ansible_ssh_private_key_file=$PRIVATE_KEY

[all:vars]
#ansible_python_interpreter=/usr/bin/python3
" | sudo tee "$INVENTORY_FILE"

# Set permissions for .ansible and .ssh directories and files
sudo chown -R jenkins:jenkins $JENKINS_HOME/.ansible
sudo chown -R jenkins:jenkins $JENKINS_HOME/.ssh
sudo chmod 700 $SSH_DIR
sudo chmod 600 "$PRIVATE_KEY"
sudo chmod 644 "$SSH_DIR/id_rsa.pub"
sudo chmod 644 "$SSH_DIR/known_hosts"

# Add the remote server's SSH host key to known_hosts to avoid verification failures
ssh-keyscan -H $REMOTE_HOST >> $KNOWN_HOSTS

# Run a test Ansible ping command to verify connectivity
export ANSIBLE_CONFIG="$ANSIBLE_CFG"
ansible test -m ping || { echo "Ansible ping test failed"; exit 1; }

# Print status message
echo "Ansible has been installed, configured, and verified."
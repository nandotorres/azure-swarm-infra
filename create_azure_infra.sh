#!/bin/bash

azure config mode arm
azure group create docker-swarm eastus
azure network vnet create docker-swarm swarm-vnet eastus -a "10.0.0.0/24"
azure network vnet subnet create docker-swarm swarm-vnet default -a "10.0.0.0/24"
azure network nsg create docker-swarm swarm-nsg eastus
azure network nsg rule create -g "docker-swarm" -a "swarm-nsg" -n "HTTP" -d "Allow HTTP" -p "TCP" -f "0.0.0.0/24" -u "80" -e "0.0.0.0/24" -c "Allow" -r "Inbound" -y "100"
azure network nsg rule create -g "docker-swarm" -a "swarm-nsg" -n "8080" -d "Custom" -p "TCP" -f "0.0.0.0/24" -u "8080" -e "0.0.0.0/24" -c "Allow" -r "Inbound" -y "110"

vms="manager1 manager2 manager3 worker1 worker2 worker3"

for vm in $vms; do
  azure network public-ip create docker-swarm "$vm-IP" eastus
  azure network nic create -n "$vm-nic" -l eastus -o "swarm-nsg" -g "docker-swarm" --subnet-name "default"
  azure vm create docker-swarm $vm eastus --nic-name "$vm-nic" -y "Linux" -Q "UbuntuLTS" -u "nandotorres" --ssh-publickey-file ~/.ssh/id_rsa.pub -z "Basic_A1" --vnet-name "swarm-vnet" --vnet-subnet-name "default" --public-ip-name "$vm-IP" --custom-data "./provision.sh"
done


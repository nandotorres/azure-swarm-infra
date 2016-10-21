#!/bin/bash

vms="manager1 manager2 manager3 worker1 worker2 worker3"

for vm in $vms; do
  azure vm start docker-swarm $vm
done
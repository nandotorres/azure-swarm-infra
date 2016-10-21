#!/bin/bash

curl -fsSL https://get.docker.com/ | sh
DOCKER_OPTS='-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock'
sudo service docker restart
#!/bin/bash -e

docker build -t dockerregistry.seekinfra.com/library/eb-deployer:$BUILD_NUMBER .
docker tag -f dockerregistry.seekinfra.com/library/eb-deployer:$BUILD_NUMBER dockerregistry.seekinfra.com/library/eb-deployer:latest
docker push dockerregistry.seekinfra.com/library/eb-deployer:$BUILD_NUMBER
docker push dockerregistry.seekinfra.com/library/eb-deployer:latest
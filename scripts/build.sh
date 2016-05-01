#!/bin/bash -e

docker build -t mefellows/eb-deployer:$BUILD_NUMBER .
docker tag -f mefellows/eb-deployer:$BUILD_NUMBER mefellows/eb-deployer:latest

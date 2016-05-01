#!/bin/bash -e

# Extract env vars from host into file
ENV_TMP=".env.tmp"
env | grep '^\S*=' > ${ENV_TMP}

# libdevmapper=$(ldconfig -p | grep 'libdevmapper.so.1.02' | awk '{print $4}')
# libudev=$(ldconfig -p | grep 'libudev.so.0' | awk '{print $4}')
# --volume $(which docker):/usr/local/bin/docker \
# --volume /var/run/docker.sock:/var/run/docker.sock \
# --volume ${libdevmapper:-/dev/null}:/usr/lib/libdevmapper.so.1.02 \
# --volume ${libudev:-/dev/null}:/usr/lib/libudev.so.0 \

# Construct the eb_deploy command from passed in arguments.
# NOTE: Passing the "$@" splat below does not work. Feel free to try though...
COMMAND="eb_deploy --debug "
for i in "$@"
do
  COMMAND="${COMMAND} $i"
done

docker run -i -t \
  --volume $(pwd):/var/app \
  --env-file ${ENV_TMP} \
  mefellows/docker-eb-deployer \
  bash -l -c "${COMMAND}"

rm ${ENV_TMP}

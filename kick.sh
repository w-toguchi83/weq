#!/bin/bash

if [ -z "${1}" ]; then
  ARG="test"
else
  ARG="${1}"
fi

case ${ARG} in
  test ) sudo docker-compose run weqtest && sudo docker-compose down;;
  server ) sudo docker-compose run --service-ports weq;;
  stop ) sudo docker-compose down;;
  * ) echo "cannot kicked [${ARG}]" >&2;;
esac

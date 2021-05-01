#!/usr/bin/env bash
mkdir ./configs
chmod 700 ./configs

echo $1 | grep rsa

if [ $? -ne 0 ]; then
  ssh-keygen -a 256 -t ed25519 -f ${1} -C ${LAPPLAND_ADMIN}
else
  # aws only supports RSA keys and only up to 4096 bytes
  ssh-keygen -a 256 -t rsa -b 4096 -f ${1} -C ${LAPPLAND_ADMIN}
fi

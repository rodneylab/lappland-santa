#!/bin/sh

# $1 - username e.g. "river.costa"
# $2 - password e.g. "P@$$w0rd"

ENCRYPTED_PASSWORD=$(smtpctl encrypt "$2")

echo ''"$(echo ${1})"'@{{ domain }}:'"$(echo ${ENCRYPTED_PASSWORD})"':vmail:2000:2000:/var/vmail/{{ domain }}/'"$(echo ${1})"'::userdb_mail=maildir:/var/vmail/{{ domain }}/'"$(echo ${1})"'' \
  >> /etc/mail/credentials


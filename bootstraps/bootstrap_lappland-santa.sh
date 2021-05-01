#!/bin/sh

# get instance type (lappland-vpn or lappland-santa)
instance_type=$(/usr/local/bin/curl -s \
  --resolve metadata.google.internal:80:169.254.169.254 \
  -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/attributes/instance-type)

# check we do not want to install lappland-vpn instead
if [instance_type == 'lappland-vpn']; then
  /usr/local/bin/curl -Lo /root/bootstrap_lappland-vpn.sh \
    https://raw.githubusercontent.com/rodneylab/lappland-vpn/main/bootstraps/bootstrap_lappland-vpn.sh
  sh /root/git/lappland-vpn/bootstraps/bootstrap_lappland-vpn.sh
  exit 0
fi

# bootstrap the system
/usr/local/bin/curl -L \
  https://raw.githubusercontent.com/rodneylab/lappland-santa/main/bootstraps/bootstrap_raw.sh \
  | sh

get_instance_keys() {
  aws_test=$(curl -o /dev/null --silent -Iw '%{http_code}' \
    http://169.254.169.254/latest/meta-data/)
  if [ "$aws_test" == "200" ]; then
      # aws
      instance_keys="$(/usr/local/bin/curl -s \
              http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key)"
      echo $instance_keys
  else
    do
      # gcloud
      instance_keys=$(/usr/local/bin/curl -s \
        --resolve metadata.google.internal:80:169.254.169.254 \
        -H "Metadata-Flavor: Google" \
        http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh-keys)
      echo $instance_keys
    done
  fi
}

get_admin_username () {
  if [ -z "$1" ]; then
    echo "lappland"
  else
    echo "$1" | while read line
  do
    # username="$(echo $line | cut -d: -f1)"
    username="$(echo $line | awk '{print $NF}')"
    echo $username
  done
  fi
}

get_public_key () {
  if [ -z "$1" ]; then
    echo ""
  else
    echo "$1" | while read line
  do
    # works for both 'user:key comment' format and 'key comment' format
    user_key="$(echo $line | cut -d: -f2)"
    echo $user_key
  done
fi
}

instance__keys = get_instance_keys
admin_account=$(get_admin_username "$instance_keys")
admin_ssh_public_key=$(get_public_key "$instance_keys")

# set lappland_id from metadata
lappland_id=$(/usr/local/bin/curl -s \
  --resolve metadata.google.internal:80:169.254.169.254 \
  -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/attributes/lappland-id)
if [ "$lappland_id" == "" ]
then
    lappland_id=lappland
fi

# get random services address
services_address="10.172.$((RANDOM % 254 + 1)).$((RANDOM % 254 + 1))"

# Extra variables for playbook
lappland_server_ip=$(/usr/local/bin/curl -L https://diagnostic.opendns.com/myip)
public_net=$(ifconfig vio0 | grep inet | awk '{print $2}')
extra_vars=$( /usr/local/bin/jq -n \
              --arg admin_account "$admin_account" \
              --arg admin_ssh_public_key "$admin_ssh_public_key" \
              --arg lappland_id "$lappland_id" \
              --arg pub_add "$lappland_server_ip" \
              --arg pub_net "$public_net" \
              --arg services_address "$services_address" \
              '{
                "admin_account":$admin_account,
                "admin_ssh_public_key":$admin_ssh_public_key,
                "lappland_id":$lappland_id,
                "lappland_server_ip":$pub_add,
                "public_net":$pub_net,
                "role_sysctl_task":"router_sysctl",
                "services_address":$services_address,
                "ssh_port":"1551",
              }'
)

# Run playbook
cd /root/git/lappland-santa/ && /usr/local/bin/ansible-playbook install.yml \
  --tag=users,system,sysctl,pf-base,dnscrypt-proxy,unbound,hardening,reboot \
  --extra-vars="$extra_vars" 2>&1 | tee -a /var/log/bootstrap \
  && touch "/var/log/lappland-result.json"

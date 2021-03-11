## Unreleased

### Fix

- **roles/wireguard-configs**: ✅ corrected templating parameter
- 💫 changed handling of smtpd db it is now overwritten if it already exists

## 0.3.0 (2021-03-10)

### Fix

- **terraform/gcloud**: ✅ added web and mail ports to their own firewalls
- **roles/wireguard-configs**: ✅ fixed template parameter
- **engage.py**: ✅ added missing environment variable from domain
- **roles/mail-server**: 💫 improved registration of dkim public key
- **roles/mail-server**: 💫 updated regex in task
- **roles/mail-server**: ✅ generate sendgrid certificate and fixed error in dovecot config and smtpd tmplate
- **roles/mail-server**: ✅ fixed typos in tasks
- **roles/mail-server**: ✅ fixes in tasks and dovecot config
- **roles/mail-server**: 💫 added missing file updated tasks
- **roles/mail-server**: ✅ fixed typo in task
- **roles/mail-server**: ✅ fixes to configuration files and task ordring
- **server.yml**: ✅ fixed vars import
- **server.yml**: ✅ fixed file import
- **roles/mail-server**: ✅ fixed acme conf file
- **roles/mail-server**: ✅ refactored deploy of relayd.conf and fixed typo
- **server.sh**: ✅ added missing variable
- **server.sh**: ✅ added missing variable
- **roles/mail-server**: 💫 updated pf rules
- **roles/mail-server**: 💫 updated handlers
- **roles/mail**: ✅ switched task order so db is in place when aliases is run
- **roles/mail-server**: 💫 updated task
- **terraform/gcloud**: ✅ fixed typo
- **server.yml**: 💫 added vars_files
- **roles/mail**: ✅ fixed variable name
- **roles/wireguard-configs**: 💫 removed IP forwarding
- **roles/unbound**: 💫 updated unbound tasks - start unbound later
- **bootstraps**: ✅ fixed typos and formatting
- **terraform/gcloud**: ✅ fixed image link
- **terraform/gcloud**: 💫 updated gcloud main terraform file
- **engage.py**: 💫 updated engage script
- **engage.py**: 💫 removed wgcf prompt from engage.py
- **terraform/gcloud**: 💫 updated image terraform
- **engage.py**: 💫 updated gcloud engage script to include image upload
- **bootstraps**: ✅ fixed typo on instance type metadata fetch
- **roles**: 💫 updated templates to reflect new secret naming convention
- **roles/mail-server**: 💫 updated main task and multiple template files
- **terraform/gcloud**: 💫 added new instance-type metadata and set PTR record for instance
- **server.yml**: 💫 added hardening to configuration tasks
- **roles/system**: 💫 updated path for sftp in sshd config, removed shutdown script, added sysmerge to doas
- **roles/mail-server**: 💫 updated mail server
- **roles/wireguard-pf**: 💫 updated pf rules
- **root**: 💫 updated scripts for santa
- **secrets**: 💫 updated secrets files
- **bootstrap_raw**: 💫 updated bootstrap_raw for santa
- **roles/unbound**: updated blocklist script to output smaller files
- **roles/wireguard-configs**: 💫 added update to unbounf configuration to allow queries from WireGuard peers
- **roles/mail**: ✅ fixed newaliases command
- **roles/cloudflare-warp**: 💫 updated pf rules

### Refactor

- **roles/mail-server**: 🛁 reformatted tasks
- 🛁 renamed variable server_public_address to lappland_server_ip
- **roles/cloudflare-warp**: 💥 removed vpn role not needed by santa

### Feat

- **roles/ssh-secure**: ✨ added new advanced ssh-secure role
- **engage.py**: ✨ updated engage.py to write system properties to files also linted file
- **bootstrap**: ✨ added santa bootstrap
- **role/mail-server**: ✨ added mail server role

## 0.2.0 (2021-03-05)

### Fix

- **server.yml**: 🕚 increase wait time for infrastructure build
- **roles/cloudflare**: ✅ removed superfluous condition on task
- **ansible.cfg**: 💫 tweaked parameters
- **roles/cloudflare-warp**: ✅ fixed condition in tasks
- **server.yml**: 🛁 added names to shell tasks
- **roles/cloudflare-warp**: 💫 added check fo existing credentials so new ones are only generated when needed
- **server.yml**: 💫 updated server.yml
- **roles/cloudflare-warp**: 💫 updated pf rules
- **roles/cloudflare-warp**: ✅ added go install to tasks
- **roles/ids**: 💫 updated suricata service
- **server.yml**: 💫 updated tasks
- **server.sh**: ✅ added missing variable
- **roles/mail**: ✅ fixed variable name
- **server.sh**: 💫 updated variable and added install of crypto collection
- **roles/wireguard-pf**: 💫 updated rules
- **roles/wireguard-config**: ✅ corrected IP address
- **server.yml**: 💫 reordered existing tasks and added new ones
- **server.sh**: 💫 added missing variables, added extra flag, reformatted
- **roles/system**: 💫 updated doas permissions
- **roles/mail**: 💫 updated tasks
- **roles/ids**: ✅ updated ip address
- **main.yml**: 💫 updated main.yml
- **server.yml**: ✅ fixed typos
- **roles/mail**: 💫 updated mail role
- **server.yml**: ✅ fixed typo in server.yml
- **server.sh**: ✅ fixed typos in server.sh
- **roles/mail**: 💫 updated mail role
- **requirements**: 💫 updated requirements.txt
- **requirements**: 💫 added ansible and netaddr to requirements
- **roles/mfa**: 💫 updated mfa tasks
- **roles/ids**: 💫 updated ids tasks
- **roles/wireguard**: 💫 updated pf rules
- **roles/mail**: 💫 updated mail role adding handler
- **roles/pf-base**: 💫 updated rules
- **roles/pf-base**: 💫 added syncookies
- **roles/hardening**: 🛁 removed superfluous line
- **bootstraps**: ✅ fixed variable name
- **roles/encrypted-dns**: ✅ added missing script to the encrypted-dns role's templates
- **roles/encrypted-dns**: ✅ added missing script to the encrypted-dns role's templates
- **roles/dnscrypt-wrapper**: ✅ fixed variable name in functions template
- **roles/encrypted-dns**: ✅ added specific package version for autoconf
- **roles/unbound**: 💫 reordered tasks in unbound role
- **terraform/gcloud**: ✅ added missing cloudresourcemanager.googleapis.com to project resources
- **roles/unbound**: ✅ corrected path for zone-block files
- **bootstraps**: ✅ debugged fetching on metadata
- **roles**: 💫 updated roles to use openbsd_pkg instead of community.general version
- **roles**: 💫 updated roles to use openbsd_pkg instead of community.general version
- **bootstraps**: ✅ updated repo clone to use https instead of ssh
- **bootstraps**: ✅ fixed unquoted paths
- **terraform/gcloud**: ✅ corrected fields in config
- **engage.py**: ✅ corrected bucket name
- **setup**: 💫  improved setup and its handling inputs
- **hardening**: ✅ fixed typo in ansible hardening role
- **README.md**: 📚 updated README.md
- **gcloud/main.tf**: 💫 debugging and improvements in execution
- **engage.py**: 💫 improvments and corrections to execution
- 💫 updated handling of project_id, now read from environment, region set in config
- **engage.py**: ✅ corrected ssh public key filename
- **gcloud/main.tf**: ✅ fixed typo

### Perf

- **ansible.cfg**: 🕚 increased timeout

### Feat

- **ansible.cfg**: ✨ added ansible.cfg file
- **configuration**: 💫 updated setup for lappland server configuration on infrastructure deploy
- **roles/cloudflare-warp**: ✨ added new role allowing vpn connection to be tunnelled through Cloudflare Warp
- **roles/monitoring**: ✨ added role enabling monitoring
- **roles/mfa**: ✨ added new role adding Duo mfa login support
- **roles/ids**: ✨ created role enabling Intrusion Detection System
- **roles/mail**: 💫 added role provided mail support
- **roles/wireguard**: ✨ added roles for WireGuard support

### Refactor

- **generate-ssh-keys.sh**: 🛁 linted file
- **roles/system**: 🛁 renamed tasks
- **dnscrypt-proxy**: 🛁 renamed task
- **terraform/gcloud**: 🛁 refactored image setup out of compute setup

## 0.1.0 (2021-02-27)

### Feat

- 🚀 initial commit

# 📮 Lappland Santa
**WARNING** this project is still under development.  Some functionality may not behave as expected. Do not rely on any output generated. ❗️

Lappland Santa is a security-focused, self-hosted, cloud mail server running on OpenBSD.  OpenBSD is a <a aria-label="Learn more about Open B S D" href="https://www.openbsd.org/" target="_blank" rel="noopener noreferrer">proactively secure</a> UNIX-like operating system.  The mail server supports modern protocols like IMAP and uses trusted tools like Dovecot, OpenSMTPD, RSpamD and Redis to deliver reliability and security.

## ☁️ Cloud Platform Setup
Currently only Google Cloud is supported.  Follow the <a href="./docs/gcloud.md">Google Cloud Platform setup instructions</a> before creating your cloud VPN instance.

## 🔌 Lappland Santa setup
1. Clone this repo:
```bash
git clone https://github.com/rodneylab/lappland-santa.git
```

2. Install core dependencies:
- OpenBSD
```bash
pkg_add python py3-pip terraform
ln -sf /usr/local/bin/bin/pip3 /usr/local/bin/pip
pip install --user --upgrade virtualenv
```

- MacOS
```bash
python3 -m pip install --user --upgrade virtualenv
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

3. Install remaining dependencies
```bash
cd lappland-vpn
python3 -m virtualenv --python="$(command -v python3)" .env && \
    . .env/bin/activate && python3 -m pip install -U pip virtualenv && \
    python3 -m pip install -r requirements.txt
```

4. Run installer
```bash
sh lappland.sh
```


## 🍭 Congratulations
You have set up you new Lappland Santa mail server. ☕️ Sit back and wait for the fan mail to start rolling in!

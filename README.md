# 📮 Lappland Santa
[![Open in Visual Studio Code](https://open.vscode.dev/badges/open-in-vscode.svg)](https://open.vscode.dev/rodneylab/lappland-santa)

**WARNING** this project is still under development.  Some functionality may not behave as expected. Do not rely on any output generated. ❗️

Lappland Santa is a security-focused, self-hosted, cloud mail server running on OpenBSD.  OpenBSD is a <a aria-label="Learn more about Open B S D" href="https://www.openbsd.org/" target="_blank" rel="noopener noreferrer">proactively secure</a> UNIX-like operating system.  The mail server supports modern protocols like IMAP and uses trusted tools like Dovecot, OpenSMTPD, Rspamd and Redis to deliver reliability and security.

## 🌟 Features

- **A+** rating from <a aria-label="Open the Mozilla Observatory site" href="https://observatory.mozilla.org/" target="_blank" rel="noopener noreferrer">Mozilla Observatory</a>, <a aria-label="Open the Qualys S S L Labs site" href="https://www.ssllabs.com/index.html" target="_blank" rel="noopener noreferrer">Qualys SSL Labs</a>, <a aria-label="Open Immuni Web site:wait" href="https://www.immuniweb.com/" target="_blank" rel="noopener noreferrer">ImmuniWeb</a> and <a aria-label="Open the security headers dot com site" href="https://securityheaders.com/" target="_blank" rel="noopener noreferrer">securityheaders.com</a> for generated security headers.
- Modern encrypted email support for secure smtps prootocol with STARTLS backward-compatibility.
- Email security server DNS records generated:
    - **BIMI**
    - **SPF**
    - **DKIM**
    - **DMARC**
    - **MTA STS**
- Supports generation of **client certificates** for added security to verify email senders.
- Optional SSH access via a **WireGuard** tunnel.
- Optional multifactor (MFA/2FA) for server SSH access.

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
cd lappland-santa
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

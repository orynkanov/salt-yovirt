cmd-dnf-module-idm-DL1-profile-dns:
  cmd.run:
    - name: dnf module install idm:DL1/dns -y
    - unless: rpm -q ipa-server-dns

git-ipa-server-installer:
  git.latest:
    - require:
      - cmd: cmd-dnf-module-idm-DL1-profile-dns
    - name: https://github.com/orynkanov/ipa-server-installer.git
    - target: /opt/ipa-server-installer

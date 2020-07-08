cmd-dnf-module-idm-DL1-profile-dns:
  cmd.run:
    - name: dnf module install idm:DL1/dns -y
    - unless: rpm -q ipa-server-dns

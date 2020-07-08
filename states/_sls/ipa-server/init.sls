cmd-dnf-module-idm-DL1:
  cmd.run:
    - name: dnf module enable idm:DL1 -y

pkg-freeipa-server-dns:
  pkg.installed:
    - pkgs:
      - ipa-server
      - ipa-server-dns

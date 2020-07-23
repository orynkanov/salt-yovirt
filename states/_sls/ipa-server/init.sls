pkg-pwgen:
  pkg.installed:
    - pkgs:
      - pwgen

git-ipa-server-installer:
  git.latest:
    - name: https://github.com/orynkanov/ipa-server-installer.git
    - target: /opt/ipa-server-installer

firewalld-ipa-server:
  firewalld.present:
    - name: public
    - services:
      - freeipa-4
      - freeipa-replication
      - dns
      - ntp

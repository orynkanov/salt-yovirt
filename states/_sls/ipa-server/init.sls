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

pkg-pwgen:
  pkg.installed:
    - pkgs:
      - pwgen

{% if grains['host'] == 'ipa01' %}
{% if not salt['file.file_exists']('/etc/sssd/sssd.conf') %}
cmd-ipa-server-installer:
  cmd.run:
    - require:
      - git: git-ipa-server-installer
      - pkg: pkg-pwgen
    - name: /opt/ipa-server-installer/ipa-server-installer.sh
{% endif %}
{% endif %}

firewalld-ipa-server:
  firewalld.present:
    - name: public
    - services:
      - freeipa-4
      - freeipa-replication
      - dns
      - ntp

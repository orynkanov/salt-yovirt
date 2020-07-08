cmd-dnf-module-idm-DL1:
  cmd.run:
    - name: dnf module enable idm:DL1
{#
pkg-freeipa-server-dns:
  pkg.installed:
    - pkgs:
      - '@idm:DL1/dns'
#}
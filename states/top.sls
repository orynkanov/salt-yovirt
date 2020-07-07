{% set SRVBASE = grains.id | regex_replace('\d{2}$', '') %}

base:
  '*':
    - _srv/{{ SRVBASE }}
    - _sls/pkgs
    - _sls/salt-minion
  #   - _sls/sysctl/tcp_timestamps
  #   - _sls/zabbix-agent
  # 'os:CentOS':
  #   - match: grain
  #   - _sls/epel
  #   - _sls/ovirt-guest-agent
  #   - _sls/ipa-client
  #   - _sls/aide
  #   - _sls/selinux
  #   - _sls/yum
  #   - _sls/repos/local
  #   - _sls/ntp


zabbix-repo-pkg:
  pkg.installed:
    - sources:
      # - zabbix-release: salt://{{slspath}}/zabbix-release-4.2-2.el7.noarch.rpm
      - zabbix-release: https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm

{% set SUBJ = 'salt-py3-repo' %}
{% set STATE_pkg_repo = 'pkg' ~ sls ~ '_' ~ SUBJ %}
qwerty:
  pkg.installed:
    - sources:
      - salt-py3-repo: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm


# {% set SUBJ = 'salt-py3-repo' %}
# {% set STATE_pkg_repo = 'pkg' ~ sls ~ '_' ~ SUBJ %}
# {{ STATE_pkg_repo }}:
#   pkg.installed:
#     - sources:
#       {% if grains['osmajorrelease'] == '7' %}
#       - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm
#       {% endif %}
#       {% if grains['osmajorrelease'] == '8' %}
#       - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm
#       {% endif %}
{#
{% set SUBJ = 'salt-minion' %}
{% set STATE_pkg_minion = 'pkg' ~ sls ~ '_' ~ SUBJ %}
{{ STATE_pkg_minion }}:
  pkg.installed:
    - require:
      - pkg: {{ STATE_pkg_repo }}
    - pkgs:
      - {{ SUBJ }}

{% set SUBJ = '/etc/salt/minion_id' %}
{% set STATE_file_minion_id = 'file' ~ sls ~ '_' ~ SUBJ %}
{{ STATE_file_minion_id }}:
  file.managed:
    - require:
      - pkg: {{ STATE_pkg_minion }}
    - name: {{ SUBJ }}
    - contents:
      - {{ grains.id }}

{% set SUBJ = 'salt-minion' %}
{% set STATE_service_minion = 'service' ~ sls ~ '_' ~ SUBJ %}
{{ STATE_service_minion }}:
  service.running:
    - require:
      - pkg: {{ STATE_pkg_minion }}
    - watch:
      - file: {{ STATE_file_minion_id }}
    - name: {{ SUBJ }}
    - enable: true
    - restart: true

{% set SUBJ = '/etc/systemd/system/salt-minion.service.d/override.conf' %}
{% set STATE_file_override = 'file' ~ sls ~ '_' ~ SUBJ %}
{{ STATE_file_override }}:
  file.managed:
    - require:
      - pkg: {{ STATE_pkg_minion }}
    - name: {{ SUBJ }}
    - source: salt://{{ slspath }}/override.conf
    - makedirs: true

{% set SUBJ = 'systemctl daemon-reload' %}
{% set STATE_cmd_daemonreload = 'cmd' ~ sls ~ '_' ~ SUBJ %}
{{ STATE_cmd_daemonreload }}:
  cmd.run:
    - onchanges:
      - file: {{ STATE_file_override }}
    - name: {{ SUBJ }}
#}


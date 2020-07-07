{% set SUBJ = 'salt-py3-repo' %}
{% set STATE_pkg_repo = 'pkg' ~ sls ~ '_' ~ SUBJ %}
{{ STATE_pkg_repo }}:
  pkg.installed:
    - sources:
      {% if grains['osmajorrelease'] == '7' %}
      - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm
      {% elif grains['osmajorrelease'] == '8' %}
      - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm
      {% endif %}

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

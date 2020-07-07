{% set SUBJ = 'salt-py3-repo' %}
{% set STATE_pkg = pkg_{{ sls }}_{{ SUBJ }} %}
{{ STATE_pkg }}:
  pkg.installed:
    - sources:
      {% if grains['osmajorrelease'] == '7' %}
      - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm
      {% elif grains['osmajorrelease'] == '8' %}
      - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm
      {% endif %}

{% set SUBJ = 'salt-minion' %}
{% set STATE_pkg = pkg_{{ sls }}_{{ SUBJ }} %}
{{ STATE_pkg }}:
  pkg.installed:
    - require:
      - pkg: {{ STATE_pkg }}
    - pkgs:
      - {{ SUBJ }}

{% set SUBJ = '/etc/salt/minion_id' %}
{% set STATE_file = file_{{ sls }}_{{ SUBJ }} %}
{{ STATE_file }}:
  file.managed:
    - require:
      - pkg: {{ STATE_pkg }}
    - name: {{ SUBJ }}
    - contents:
      - {{ grains.id }}

{% set SUBJ = 'salt-minion' %}
{% set STATE_service = service_{{ sls }}_{{ SUBJ }} %}
{{ STATE_service }}:
  service.running:
    - require:
      - pkg: {{ STATE_pkg }}
    - watch:
      - file: {{ STATE_file }}
    - name: {{ SUBJ }}
    - enable: true
    - restart: true

{% set SUBJ = '/etc/systemd/system/salt-minion.service.d/override.conf' %}
{% set STATE_file = file_{{ sls }}_{{ SUBJ }} %}
{{ STATE_file }}:
  file.managed:
    - name: {{ SUBJ }}
    - source: salt://{{ slspath }}/override.conf
    - makedirs: true

{% set SUBJ = 'systemctl daemon-reload' %}
{% set STATE_cmd = cmd_{{ sls }}_{{ SUBJ }} %}
{{ STATE_cmd }}:
  cmd.run:
    - onchanges:
      - file: {{ STATE_file }}
    - name: {{ SUBJ }}

{% set SUBJ = 'salt-py3-repo' %}
{% set STATEpkg = pkg-{{ sls }}-{{ SUBJ }} %}
{{ STATEpkg }}:
  pkg.installed:
    - sources:
      {% if grains['osmajorrelease'] == '7' %}
      - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm
      {% elif grains['osmajorrelease'] == '8' %}
      - {{ SUBJ }}: https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm
      {% endif %}

{% set SUBJ = 'salt-minion' %}
{% set STATEpkg = pkg-{{ sls }}-{{ SUBJ }} %}
{{ STATEpkg }}:
  pkg.installed:
    - require:
      - pkg: {{ STATEpkg }}
    - pkgs:
      - {{ SUBJ }}

{% set SUBJ = '/etc/salt/minion_id' %}
{% set STATEfile = file-{{ sls }}-{{ SUBJ }} %}
{{ STATEfile }}:
  file.managed:
    - require:
      - pkg: {{ STATEpkg }}
    - name: {{ SUBJ }}
    - contents:
      - {{ grains.id }}

{% set SUBJ = 'salt-minion' %}
{% set STATEservice = service-{{ sls }}-{{ SUBJ }} %}
{{ STATEservice }}:
  service.running:
    - require:
      - pkg: {{ STATEpkg }}
    - watch:
      - file: {{ STATEfile }}
    - name: {{ SUBJ }}
    - enable: true
    - restart: true

{% set SUBJ = '/etc/systemd/system/salt-minion.service.d/override.conf' %}
{% set STATEfile = file-{{ sls }}-{{ SUBJ }} %}
{{ STATEfile }}:
  file.managed:
    - name: {{ SUBJ }}
    - source: salt://{{ slspath }}/override.conf
    - makedirs: true

{% set SUBJ = 'systemctl daemon-reload' %}
{% set STATEcmd = cmd-{{ sls }}-{{ SUBJ }} %}
{{ STATEcmd }}:
  cmd.run:
    - onchanges:
      - file: {{ STATEfile }}
    - name: {{ SUBJ }}

{% set SUBJ = ['salt-master', 'salt-ssh', 'salt-api'] %}
{% set STATEpkg = pkg-{{ sls }}-{{ SUBJ | join(',') }} %}
{{ STATEpkg }}:
  pkg.installed:
    - pkgs:
      {% for PKG in SUBJ %}
      - {{ PKG }}
      {% endfor %}

{% set SUBJ = '/etc/salt/master.d' %}
{% set STATEfile = file-{{ sls }}-{{ SUBJ }} %}
{{ STATEfile }}:
  file.recurse:
    - require:
      - pkg: {{ STATEpkg }}
    - name: {{ SUBJ }}
    - source: salt://{{ slspath }}/{{ salt['file.basename'](SUBJ) }}

{% set SUBJ = 'salt-master' %}
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

{% set SUBJ = 'salt-api' %}
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

# {% set SUBJ = '/srv/reactor' %}
# {% set STATEfile = file-{{ sls }}-{{ SUBJ }} %}
# STATEfile:
#   file.recurse:
#     - require:
#       - pkg: {{ STATEpkg }}
#     - name: {{ SUBJ }}
#     - source: salt://{{ slspath }}/{{ salt['file.basename'](SUBJ) }}

# #need for salt pam
# {% set SUBJ = '/var/log/salt/master' %}
# {% set STATEfile = file-{{ sls }}-{{ SUBJ }} %}
# STATEfile:
#   file.managed:
#     - require:
#       - pkg: {{ STATEpkg }}
#     - name: {{ SUBJ }}
#     - mode: '0664'
#     - group: admins

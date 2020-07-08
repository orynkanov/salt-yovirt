pkg-salt-master:
  pkg.installed:
    - pkgs:
      - salt-master
      - salt-ssh
      - salt-api

file-master.d:
  file.recurse:
    - require:
      - pkg: pkg-salt-master
    - name: /etc/salt/master.d
    - source: salt://{{ slspath }}/master.d

service-salt-master:
  service.running:
    - require:
      - pkg: pkg-salt-master
    - watch:
      - file: file-master.d
    - name: salt-master
    - enable: true
    - restart: true

service-salt-api:
  service.running:
    - require:
      - pkg: pkg-salt-master
    - watch:
      - file: file-master.d
    - name: salt-api
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

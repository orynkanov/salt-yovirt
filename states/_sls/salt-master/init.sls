{% set SUBJ = ['salt-master', 'salt-ssh', 'salt-api'] %}
{% set STATE_pkg = pkg_{{ sls }}_{{ SUBJ | join(',') }} %}
{{ STATE_pkg }}:
  pkg.installed:
    - pkgs:
      {% for PKG in SUBJ %}
      - {{ PKG }}
      {% endfor %}

{% set SUBJ = '/etc/salt/master.d' %}
{% set STATE_file = file_{{ sls }}_{{ SUBJ }} %}
{{ STATE_file }}:
  file.recurse:
    - require:
      - pkg: {{ STATE_pkg }}
    - name: {{ SUBJ }}
    - source: salt://{{ slspath }}/{{ salt['file.basename'](SUBJ) }}

{% set SUBJ = 'salt-master' %}
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

{% set SUBJ = 'salt-api' %}
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

# {% set SUBJ = '/srv/reactor' %}
# {% set STATE_file = file_{{ sls }}_{{ SUBJ }} %}
# STATE_file:
#   file.recurse:
#     - require:
#       - pkg: {{ STATE_pkg }}
#     - name: {{ SUBJ }}
#     - source: salt://{{ slspath }}/{{ salt['file.basename'](SUBJ) }}

# #need for salt pam
# {% set SUBJ = '/var/log/salt/master' %}
# {% set STATE_file = file_{{ sls }}_{{ SUBJ }} %}
# STATE_file:
#   file.managed:
#     - require:
#       - pkg: {{ STATE_pkg }}
#     - name: {{ SUBJ }}
#     - mode: '0664'
#     - group: admins

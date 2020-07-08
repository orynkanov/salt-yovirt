{% if grains.os == 'CentOS' %}
  {% if grains.osmajorrelease == 7 %}
    {% set SALTREPO = 'https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm' %}
  {% elif grains.osmajorrelease == 8 %}
    {% set SALTREPO = 'https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm' %}
  {% endif %}
{% endif %}

pkg-salt-repo:
  pkg.installed:
    - sources:
      - salt-py3-repo: {{ SALTREPO }}

pkg-salt-minion:
  pkg.installed:
    - require:
      - pkg: pkg-salt-repo
    - pkgs:
      - salt-minion

file-minion_id:
  file.managed:
    - require:
      - pkg: pkg-salt-minion
    - name: /etc/salt/minion_id
    - contents:
      - {{ grains.id }}

service-salt-minion:
  service.running:
    - require:
      - pkg: pkg-salt-minion
    - watch:
      - file: file-minion_id
    - name: salt-minion
    - enable: true
    - restart: true

file-override.conf:
  file.managed:
    - require:
      - pkg: pkg-salt-minion
    - name: /etc/systemd/system/salt-minion.service.d/override.conf
    - source: salt://{{ slspath }}/override.conf
    - makedirs: true

cmd-daemon-reload:
  cmd.run:
    - onchanges:
      - file: file-override.conf
    - name: systemctl daemon-reload

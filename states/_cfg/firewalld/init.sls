file-firewalld.conf:
  file.managed:
    - name: /etc/firewalld/firewalld.conf
    - source: salt://{{ slspath }}/firewalld.conf.{{ grains.osmajorrelease }}

cmd-firewalld-reload:
  cmd.run:
    - onchanges:
      - file: file-firewalld.conf
    - name: firewall-cmd --reload

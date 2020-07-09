file-firewalld.conf:
  file.managed:
    - name: /etc/firewalld/firewalld.conf
    - source: salt://{{ slspath }}/firewalld.conf.centos{{ grains.osmajorrelease }}

service-firewalld:
  service.running:
    - watch:
      - file: file-firewalld.conf
    - name: firewalld
    - enable: true
    - restart: true

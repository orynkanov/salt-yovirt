{% set SUBJ = ['mc', 'bash-completion', 'htop', 'screen'] %}
{% set STATE_pkg = pkg-{{ sls }}-{{ SUBJ | join(',') }} %}
{{ STATE_pkg }}:
  pkg.installed:
    - pkgs:
      {% for PKG in SUBJ %}
      - {{ PKG }}
      {% endfor %}

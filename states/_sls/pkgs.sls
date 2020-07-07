{% set SUBJ = ['mc', 'bash-completion', 'htop', 'screen'] %}
{% set STATEpkg = pkg-{{ sls }}-{{ SUBJ | join(',') }} %}
{{ STATEpkg }}:
  pkg.installed:
    - pkgs:
      {% for PKG in SUBJ %}
      - {{ PKG }}
      {% endfor %}

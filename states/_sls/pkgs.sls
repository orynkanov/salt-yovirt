{#
{% set SUBJ = ['mc', 'bash-completion', 'htop', 'screen'] %}
{% set STATEpkg = pkg-{{ sls }}-{{ SUBJ | join(',') }} %}
{{ STATEpkg }}:
  pkg.installed:
    - pkgs:
      {% for PKG in SUBJ %}
      - {{ PKG }}
      {% endfor %}
#}
{% set SUBJ = ['mc', 'bash-completion', 'htop', 'screen'] %}
{% set STATE_pkg_pkgs = 'pkg_' ~ sls ~ '_' ~ SUBJ %}
{{ STATE_pkg_pkgs }}:
  pkg.installed:
    - pkgs:
      {% for PKG in SUBJ %}
      - {{ PKG }}
      {% endfor %}

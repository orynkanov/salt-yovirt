{{ sls }}-pkg:
  pkg.installed:
    - pkgs:
      - mc
      - bash-completion
      - htop
      - screen

pkg-ipa-client:
  pkg.installed:
    - pkgs:
      - ipa-client

git-ipa-client-installer:
  git.latest:
    - require:
      - pkg: pkg-ipa-client
    - name: https://github.com/orynkanov/ipa-client-installer.git
    - target: /opt/ipa-client-installer

plenv:
  # See https://github.com/kwakwaversal/saltstack-formula-plenv/blob/master/pillar.example
  perl:
    global: 5.24.0
    packages:
      - Carton
    versions:
      - 5.24.0

  users:
    vagrant:
      user: vagrant
      group: vagrant

ndenv:
  # The version of node to be installed for all users. N.B., this can be
  # overridden per user.
  node:
    global: 6.9.0
    versions:
      - 6.9.0

  users:
    vagrant:
      user: vagrant
      group: vagrant

# See https://github.com/saltstack-formulas/postgres-formula/blob/master/pillar.example
postgres:
  # Set True to configure upstream postgresql.org repository for YUM or APT
  use_upstream_repo: True

  # v9.5 has some nice features
  version: '9.5'

  # These are Debian/Ubuntu specific package names
  pkg: 'postgresql-9.5'
  pkg_client: 'postgresql-client-9.5'

  # Additional packages to install with PostgreSQL server,
  # this should be in a list format
  pkgs_extra:
    - postgresql-contrib-9.5

  # Path to the `pg_hba.conf` file Jinja template on Salt Fileserver
  pg_hba.conf: salt://postgres/templates/pg_hba.conf.j2

  # This section covers ACL management in the `pg_hba.conf` file.
  # acls list controls: which hosts are allowed to connect, how clients
  # are authenticated, which PostgreSQL user names they can use, which
  # databases they can access. Records take one of these forms:
  #
  # acls:
  #  - ['local', 'DATABASE',  'USER',  'METHOD']
  #  - ['host', 'DATABASE',  'USER',  'ADDRESS', 'METHOD']
  #  - ['hostssl', 'DATABASE', 'USER', 'ADDRESS', 'METHOD']
  #  - ['hostnossl', 'DATABASE', 'USER', 'ADDRESS', 'METHOD']
  #
  # The uppercase items must be replaced by actual values.
  # METHOD could be omitted, 'md5' will be appended by default.
  acls:
    - ['local', 'all', 'all', 'peer']
    - ['host', 'all', 'all', '127.0.0.1/32']
    - ['host', 'all', 'all', '::1/128']
    - ['host', 'all', 'all', '0.0.0.0/0']

  # PostgreSQL service name
  service: postgresql

  # Create/remove users, tablespaces, databases, schema and extensions.
  # Each of these dictionaries contains PostgreSQL entities which
  # mapped to the `postgres_*` Salt states with arguments. See the Salt
  # documentaion to get all supported argument for a particular state.
  #
  # Format is the following:
  #
  # <users|tablespaces|databases|schemas|extensions>:
  #  NAME:
  #    ensure: <present|absent>  # 'present' is the default
  #    ARGUMENT: VALUE
  #    ...
  #
  # where 'NAME' is the state name, 'ARGUMENT' is the kwarg name, and
  # 'VALUE' is kwarg value.
  #
  # For example, the Pillar:
  #
  # users:
  #  testUser:
  #    password: test
  #
  # will render such state:
  #
  # postgres_user-testUser:
  #  postgres_user.present:
  #    - name: testUser
  #    - password: test
  users:
    vagrant:
      ensure: present
      password: password
      createdb: True
      createroles: False
      createuser: False
      inherit: True
      replication: False

  databases:
{% for db in ['scrabblicious'] %}
    {{ db }}:
      owner: vagrant
{% endfor %}

  schemas:
    scrabblicious:
      dbname: scrabblicious
      owner: vagrant

  extensions:
    pgcrypto:
      schema: scrabblicious
      maintenance_db: scrabblicious

  # This section will append your configuration to postgresql.conf.
  postgresconf: |
    listen_addresses = '*'

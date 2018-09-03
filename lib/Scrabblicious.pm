package Scrabblicious;
use Mojo::Base 'Mojolicious';

use Scrabblicious::Schema;

has schema => sub {
  my $c = shift;

  my $db = $c->config->{datasources}->{scrabblicious};
  $c->log->debug(
    "Connecting to postgresql://$db->{username}\@$db->{host}/$db->{schema}.$db->{database}"
  );
  state $schema = Scrabblicious::Schema->connect(
    "dbi:Pg:dbname=$db->{database};host=$db->{host}",
    $db->{username},
    $db->{password},
    {
      pg_enable_utf8 => 1,
      quote_names    => 1,
      on_connect_do  => [
        "SET TIME ZONE 'UTC'",
        'SET search_path TO ' . ($db->{schema} // 'public')
      ]
    }
  );

  return $schema;
};

# Mojolicious::Plugin::RESTify route configuration
has restify_routes => sub {
  return {'leaderboards' => undef, 'players' => undef};
};

# This method will run once at server start
sub startup {
  my $self = shift;

  # Add the Scrabblicious namespace for commands
  push @{$self->app->commands->namespaces}, 'Scrabblicious::Command';

  # Database helpers
  $self->helper(db => sub { $self->app->schema });

  # Plugins
  $self->plugin($_) for qw/Config Restify PODRenderer/;
  $self->plugin("Scrabblicious::Plugin::$_") for qw/API Hooks/;

  # Hooks
  # See Scrabblicious::Plugin::Hooks

  # Router
  my $r = $self->routes;
  $r->get('/')->to(
    cb => sub {
      my $self = shift;
      $self->redirect_to('players_list');
    }
  )->name('home');

  # Sets up CRUD routes using Mojolicious::Plugin::Restify
  $self->restify->routes($r, $self->restify_routes, {over => 'uuid'});

  $self->restify->routes(
    $self->routes,
    ['accounts', ['accounts/invoices' => {over => 'uuid'}]],
    {over => 'int'}
  );
}

1;

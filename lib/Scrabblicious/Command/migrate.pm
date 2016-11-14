package Scrabblicious::Command::migrate;
use Mojo::Base 'Mojolicious::Command';

use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev);
use Mojo::Pg;

has description => 'Migrate database to a specific version using Mojo::Pg::Migrations';
has usage => sub { shift->extract_usage };

sub run {
  my ($self, @args) = @_;

  GetOptionsFromArray \@args,
    'd|drop'      => \(my $drop    = 0),
    'l|latest'    => \(my $latest  = 0),
    'r|reset'     => \(my $reset   = 0),
    'v|version=i' => \(my $version = -1);

  my $db = $self->app->config->{datasources}->{scrabblicious};
  my $pg
    = Mojo::Pg->new(
    "postgresql://$db->{username}:$db->{password}\@$db->{host}/$db->{database}"
    )->search_path([$db->{schema}]);

  my $path      = $self->app->home->rel_file('migrations/scrabblicious.sql');
  my $migration = $pg->migrations->name('scrabblicious')->from_file($path);

  if ($latest) {
    print "Migrating to the latest version.\n";
    $migration->migrate;
  }
  elsif ($version >= 0) {
    print "Migrating database to version $version.\n";
    $migration->migrate($version);
  }
  elsif ($drop) {
    print "Dropping database.\n";
    $migration->migrate(0);
  }
  elsif ($reset) {
    print "Resetting database.\n";
    $migration->migrate(0)->migrate;
  }
  else {
    die shift->extract_usage;
  }
}

1;

=head1 NAME

Scrabblicious::Command::migrate - Migrate database to a specific version

=head1 SYNOPSIS

  Usage: APPLICATION migrate [OPTIONS]
    ./myapp.pl migrate --drop
    ./myapp.pl migrate --latest
    ./myapp.pl migrate --reset
    ./myapp.pl migrate --version 10

  Options:
    -d, --drop              Drop database (== migrate to version 0)
    -l, --latest            Bring database up to latest version
    -r, --reset             Reset database
    -v, --version <count>   Migrate to specific version

=head1 DESCRIPTION

Migrate database to a specific version using L<Mojo::Pg::Migrations> from
the L<Mojo::Pg> distribution.

It's also possible to completely drop or reset a database, but this feature
might be removed in later versions.

=head1 ATTRIBUTES

L<Scrabblicious::Command::migrate> inherits all attributes from
L<Mojolicious::Commands> and implements the following new ones.

=head2 description

  my $description = $get->description;
  $get            = $get->description('Foo!');

Short description of this command, used for the command list.

=head2 usage

  my $usage = $get->usage;
  $get      = $get->usage('Foo!');

Usage information for this command, used for the help screen.

=head1 METHODS

L<Scrabblicious::Command::migrate> inherits all methods from
L<Mojolicious::Command> and implements the following new ones.

=head2 run

  $get->run(@ARGV);

Run this command.

=head1 SEE ALSO

L<Mojolicious>.

=cut

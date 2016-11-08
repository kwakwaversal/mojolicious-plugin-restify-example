package Scrabblicious::Command::generateschema;
use Mojo::Base 'Mojolicious::Command';

use DBIx::Class::Schema::Loader qw/make_schema_at/;
use FindBin;
use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev);

has description => 'Generate DBIC schema from database';
has usage => sub { shift->extract_usage };

# Added result_base_class on recommendation from the DBIC cookbook to improve
# startup speed. As a schema matures, it will be a help.
#
# Additionally it makes it easier to load new components without rebuilding the
# schema.
#
# https://metacpan.org/pod/distribution/DBIx-Class/lib/DBIx/Class/Manual/Cookbook.pod#STARTUP-SPEED

sub run {
  my ($self, @args) = @_;

  GetOptionsFromArray \@args,
    'o|overwrite-modifications=i' => \(my $overwrite = 0);

  my $db = $self->app->config->{datasources}->{scrabblicious};

  make_schema_at(
    'Scrabblicious::Schema',
    {
      db_schema               => $db->{schema},
      relationships           => 1,
      dump_directory          => "$FindBin::Bin/../lib",
      debug                   => 1,
      overwrite_modifications => $overwrite,
      result_base_class       => 'Scrabblicious::Schema::BaseResult',
    },
    [
      "dbi:Pg:dbname=$db->{database};host=$db->{host}", $db->{username},
      $db->{password}
    ],
  );
}

1;

=head1 NAME

Scrabblicious::Command::generateschema - Generate the DBIC schema

=head1 SYNOPSIS

  Usage: APPLICATION generateschema [OPTIONS]
    ./myapp.pl generateschema
    ./myapp.pl generateschema --overwrite-modifications 1

  Options:
    -o, --overwrite-modifications <0|1>

=head1 DESCRIPTION

Generates the C<Scrabblicious> schema using L<DBIx::Class::Schema::Loader>.

=head1 ATTRIBUTES

L<Scrabblicious::Command::generateschema> inherits all attributes from
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

L<Scrabblicious::Command::generateschema> inherits all methods from
L<Mojolicious::Command> and implements the following new ones.

=head2 run

  $get->run(@ARGV);

Run this command.

=head1 SEE ALSO

L<Mojolicious>.

=cut

package Scrabblicious::Command::dummydata;
use Mojo::Base 'Mojolicious::Command';

use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev);

has description => 'Insert dummy game data for every player';
has usage => sub { shift->extract_usage };

sub run {
  my ($self, @args) = @_;

  GetOptionsFromArray \@args, 'g|games=i' => \(my $games = 25);

  my $players
    = [$self->app->db->resultset('Player')->search({status => 'Active'})->all];

  # Iterate through every player and insert dummy game data
  for my $player (@$players) {
    for (my $i = 0; $i < $games; $i++) {
      my $opponent = $players->[int(rand(@$players))];
      next if $player->id eq $opponent->id;    # can't play against yourself

      my $data = rand_data($player, $opponent);
      $self->app->db->resultset('Game')->create($data);
    }
  }
}

sub rand_data {
  my ($player, $opponent) = @_;

  my $player_score   = int(rand 350) + 150;
  my $opponent_score = int(rand 350) + 150;

  my $data = {};
  if ($player_score >= $opponent_score) {
    $data->{winner_id}    = $player->id;
    $data->{winner_score} = ++$player_score;    # bump to avoid draws
    $data->{loser_id}     = $opponent->id;
    $data->{loser_score}  = $opponent_score;
  }
  else {
    $data->{winner_id}    = $opponent->id;
    $data->{winner_score} = $opponent_score;
    $data->{loser_id}     = $player->id;
    $data->{loser_score}  = $player_score;
  }

  return $data;
}

1;

=head1 NAME

Scrabblicious::Command::dummydata - Insert dummy game data

=head1 SYNOPSIS

  Usage: APPLICATION dummydata [OPTIONS]
    ./myapp.pl dummydata
    ./myapp.pl dummydata --games 10

  Options:
    -g, --games <count>   Number of dummy games to insert for each player

=head1 DESCRIPTION

Inserts random game data into the games database table, avoiding players
playing against themselves.

=head1 ATTRIBUTES

L<Scrabblicious::Command::dummydata> inherits all attributes from
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

L<Scrabblicious::Command::dummydata> inherits all methods from
L<Mojolicious::Command> and implements the following new ones.

=head2 run

  $get->run(@ARGV);

Run this command.

=head1 SEE ALSO

L<Mojolicious>.

=cut

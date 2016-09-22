package Scrabblicious::Controller::Leaderboards;
use Mojo::Base 'Scrabblicious::Controller';

sub list {
  my $c = shift;

  my $players = $c->db->resultset('Player')->search(
    {
      'me.status' => {'='  => [qw/A/]},
      wins        => {'>=' => $c->config->{api}->{leaderboard_game_minimum}}
    },
    {
      prefetch => 'vw_scoreboard',
      order_by => {-desc => [qw/avg_score/]},
      page     => 1,
      rows     => $c->config->{api}->{leaderboard_row_limit},
    }
  );

  $c->stash(players => [$players->all]);

  # Here we could also respon to JSON to be RESTy
  $c->respond_to(any => {format => 'html', template => 'leaderboards/list'});
}

1;

=head1 NAME

Scrabblicious::Controller::Leaderboards - Leaderboards

=head1 DESCRIPTION

Lists all the players ordered by most wins.

=head1 ATTRIBUTES

L<Scrabblicious::Controller::Leaderboards> inherits all attributes from
L<Scrabblicious::Controller> and implements the following new ones.

=head1 METHODS

L<Scrabblicious::Controller::Leaderboards> inherits all methods from
L<Scrabblicious::Controller> and implements the following new ones.

=head2 create

Inherited from L<Scrabblicious::Controller>.

=head2 delete

Inherited from L<Scrabblicious::Controller>.

=head2 list

Lists all the players ordered by most wins.

=head2 read

Inherited from L<Scrabblicious::Controller>.

=head2 under

Called for every instance method apart from list and create.

This is a good place to look up the :uuid for the resource and have it available
to the rest of the chain.

=head2 update

Inherited from L<Scrabblicious::Controller>.

=head1 SEE ALSO

L<Mojolicious>.

=cut

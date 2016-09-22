package Scrabblicious::Controller::Players;
use Mojo::Base 'Scrabblicious::Controller';

sub under {
  my $c = shift;
  my $resource
    = $c->db->resultset('Player')
    ->search({'me.players_id' => $c->stash('players_id'), status => 'A'},
    {prefetch => 'vw_scoreboard'})->single;

  $c->stash(player => $resource);
  return 1 if $resource;

  $c->reply->not_found;
  return 0;
}

sub list {
  my $c = shift;

  if ($c->req->param('action') eq 'create') {
    $c->respond_to(any => {format => 'html', template => 'players/create'});
    return 1;
  }

  my $players = $c->db->resultset('Player')->search(
    {'me.status' => {'=' => [qw/A/]},},
    {
      # prefetch => 'scoreboard',
      order_by => {-asc => [qw/me.nickname/]},
      page     => $c->api->page,
      rows     => $c->api->per_page,
    }
  );

  $c->stash(players => [$players->all]);
  $c->api->pager($players->pager);

  # Here we could also respon to JSON to be RESTy
  $c->respond_to(any => {format => 'html', template => 'players/list'});
}

sub read {
  my $c = shift;

  my $player = $c->stash->{player};

  # Add the highest score match details to the stash
  if ($player->vw_scoreboard->max_score > 0) {
    my $highscore = $c->db->resultset('Game')->search(
      {
        -or => [
          -and => [
            winner_id    => $player->id,
            winner_score => $player->vw_scoreboard->max_score,
          ],
          -and => [
            loser_id    => $player->id,
            loser_score => $player->vw_scoreboard->max_score,
          ],
        ]
      }
    )->first;

    $c->stash(highscore => $highscore);
  }

  # Here we could also respon to JSON to be RESTy
  $c->respond_to(any => {format => 'html', template => 'players/read'},);
}

1;

=head1 NAME

Scrabblicious::Controller::Players - Players

=head1 DESCRIPTION

L<Scrabblicious::Controller::Players> is a CRUD controller for
L<Scrabblicious::Schema::Result::Player>.

=head1 ATTRIBUTES

L<Scrabblicious::Controller::Players> inherits all attributes from
L<Scrabblicious::Controller> and implements the following new ones.

=head1 METHODS

L<Scrabblicious::Controller::Players> inherits all methods from
L<Scrabblicious::Controller> and implements the following new ones.

=head2 create

Inherited from L<Scrabblicious::Controller>.

=head2 delete

Inherited from L<Scrabblicious::Controller>.

=head2 list

=head2 read

=head2 under

Called for every instance method apart from list and create.

This is a good place to look up the :uuid for the resource and have it available
to the rest of the chain.

=head2 update

=head1 SEE ALSO

L<Mojolicious>.

=cut

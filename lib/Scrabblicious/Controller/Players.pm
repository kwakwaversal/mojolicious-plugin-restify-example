package Scrabblicious::Controller::Players;
use Mojo::Base 'Scrabblicious::Controller';

has resultset => 'Player';

sub list {
  my $c = shift;

  if ($c->req->param('action') && $c->req->param('action') eq 'create') {
    $c->respond_to(any => {format => 'html', template => 'players/create'});
    return 1;
  }

  my $collection = $c->db->resultset('Player')
    ->list({page => $c->api->page, per_page => $c->api->per_page});
  $c->stash(collection => [$collection->all]);
  $c->api->pager($collection->pager);

  # Here we respond to JSON if requested, or default to HTML (we're SO RESTy!)
  $c->respond_to(
    json => {json => {data => $c->stash->{collection}}},
    any => {collection => $c->stash->{collection}, format => 'html'}
  );
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

=head2 list

=head1 SEE ALSO

L<Mojolicious>.

=cut

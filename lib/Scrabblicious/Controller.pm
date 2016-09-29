package Scrabblicious::Controller;
use Mojo::Base 'Mojolicious::Controller';

has lookup_resource => 1;
has resultset       => undef;

sub under {
  my $c = shift;

  # Default under returns 1 to continue the dispatch chain
  return 1 unless $c->lookup_resource && defined $c->resultset;

  # Look up the resource element using our DBIx::Class::ResultSet method
  my $resource = $c->db->resultset($c->resultset)
    ->resource({current_id => $c->restify->current_id})->single;

  $c->stash(resource => $resource);
  return 1 if $resource;

  $c->reply->not_found;
  return 0;
}

sub create { shift->reply->not_found }

sub delete { shift->reply->not_found }

sub list { shift->reply->not_found }

sub read {
  my $c = shift;

  # The resource key should be set in the derived classes
  return $c->reply->not_found unless exists $c->stash->{resource};

  # Here we respond to JSON if requested, or default to HTML (we're SO RESTy!)
  $c->respond_to(
    json => {json   => {data => $c->stash->{resource}}},
    any  => {format => 'html'}
  );
}

sub update { shift->reply->not_found }

1;

=head1 NAME

Scrabblicious::Controller - Controller base class for Scrabblicious

=head1 DESCRIPTION

L<Scrabblicious::Controller> is the base L<Mojolicious::Controller> for the
Scrabblicious API.

I've found it's a good idea to always inherit from your own C<Controller>. Doing
this allows you to quickly add attributes to all of your controllers, as well as
picking sane defaults for the methods L<Mojolicious::Plugin::RESTify>
dispatches your routes to.

=head1 ATTRIBUTES

L<Scrabblicious::Controller> inherits all attributes from
L<Mojolicious::Controller> and implements the following new ones.

=head2 lookup_resource

  sub under {
    my $c = shift;
    $c->lookup_resource(1);
    $c->resultset('Player');
    return $c->SUPER::under();
  }

If true, attempts to look up a resource in the C<under> method. Must also have
the C<resultset> attribute set for the controller you want to look up.

=head2 resultset

The name of the C<Scrabblicious> resultset this controller is associated with.

This is specific to this example, and is used with L<DBIx::Class::ResultSet>
when trying to find a resource element for a collection.

=head1 METHODS

L<Scrabblicious::Controller> inherits all methods from
L<Mojolicious::Controller> and implements the following new ones.

=head1 HTTP METHODS

Methods used to handle the actions for specific routes.

  POST    /players         # create
  DELETE  /players/:uuid   # delete
  GET     /players         # list
  GET     /players/:uuid   # read
  UPDATE  /players/:uuid   # update

=head2 create

Not implemented. Must be implemented by the subclass.

=head2 delete

Not implemented. Must be implemented by the subclass.

=head2 list

Not implemented. Must be implemented by the subclass.

=head2 read

Not implemented. Must be implemented by the subclass.

=head2 under

Called before every action apart from C<list> and C<create>. Returns 1 by
default. Returning a non-true value exits the dispatch chain, and returns a 404
not found.

This is a good place for derived classes to look up and validate the C<:uuid>
for a resource and stash it for use in the rest of the chain.

=head2 update

Not implemented. Must be implemented by the subclass.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Controller>.

=cut

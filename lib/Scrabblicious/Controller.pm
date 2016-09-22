package Scrabblicious::Controller;
use Mojo::Base 'Mojolicious::Controller';

# Default under returns 1 to continue the dispatch chain
sub under { 1 }

sub create { shift->reply->not_found }

sub delete { shift->reply->not_found }

sub list { shift->reply->not_found }

sub read { shift->reply->not_found }

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

Add your own attributes here.

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

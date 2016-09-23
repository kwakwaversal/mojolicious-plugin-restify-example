package Scrabblicious::Schema::BaseResult;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/UUIDColumns/);

sub TO_JSON {
  my $self = shift;

  # http://jsonapi.org/format/#fetching-resources
  my %resource;
  $resource{type}       = $self->result_source->name;
  $resource{id}         = $self->id;
  $resource{attributes} = {$self->get_inflated_columns};

  return \%resource;
}

1;

=head1 NAME

Scrabblicious::Schema::BaseResult

=head1 SYNOPSIS

  ...

=head1 DESCRIPTION

Base class. Optimized for startup speed and to easily apply components and
validation methods to all Results.

See L<DBIx::Class::Manual::Cookbook/STARTUP_SPEED>.

=head1 METHODS

L<Scrabblicious::Schema::BaseResult> inherits all methods from
L<DBIx::Class::Core> and implements the following new ones.

=head2 TO_JSON

When L<Mojo::JSON> is rendering, it will try and call the C<TO_JSON> method
on blessed references. By default, this will return the C<inflated_columns>
for a L<DBIx::Class::Result>.

If a result needs to return more tailored data, override this method in the
result.

=head1 AUTHOR

Paul Williams, kwakwaversal AT gmail DOT com

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

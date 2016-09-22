package Scrabblicious::Schema::BaseResult;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/UUIDColumns/);

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

=head1 AUTHOR

Paul Williams, kwakwaversal AT gmail DOT com

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

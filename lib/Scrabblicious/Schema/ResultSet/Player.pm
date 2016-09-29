package Scrabblicious::Schema::ResultSet::Player;

use strict;
use warnings;

use base 'Scrabblicious::Schema::BaseResultSet';

sub list {
  my $self = shift;
  my $params = ref $_[0] eq 'HASH' ? shift : {@_};

  $params->{order_by} //= {-desc => 'me.nickname'};
  $params->{search} //= {'me.status' => {'=' => [qw/Active/]}};

  return $self->search(
    $params->{search},
    {
      order_by => $params->{order_by},
      page     => $params->{page},
      rows     => $params->{per_page},
    }
  );
}

sub resource {
  my $self = shift;
  my $params = ref $_[0] eq 'HASH' ? shift : {@_};
  return $self->search(
    {'me.players_id' => $params->{current_id}, status => 'Active'});
}

1;

=head1 NAME

Scrabblicious::Schema::ResultSet::Player

=head1 DESCRIPTION

...

=head1 METHODS

L<Scrabblicious::Schema::ResultSet::Player> inherits all methods from
L<Scrabblicious::Schema::BaseResultSet> and implements the following new ones.

=head2 resource

  my $resource = $c->db->resultset($c->resultset)
    ->resource({current_id => $c->restify->current_id})->single;

Returns the search to use when looking up a resource element.

=head1 SEE ALSO

L<DBIx::Class>, L<Scrabblicious>.

=cut

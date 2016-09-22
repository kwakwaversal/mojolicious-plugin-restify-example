use utf8;
package Scrabblicious::Schema::Result::VwScoreboard;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scrabblicious::Schema::Result::VwScoreboard

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<Scrabblicious::Schema::BaseResult>

=cut

use base 'Scrabblicious::Schema::BaseResult';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<vw_scoreboard>

=cut

__PACKAGE__->table("vw_scoreboard");

=head1 ACCESSORS

=head2 players_id

  data_type: 'uuid'
  is_nullable: 1
  size: 16

=head2 games

  data_type: 'bigint'
  is_nullable: 1

=head2 wins

  data_type: 'bigint'
  is_nullable: 1

=head2 losses

  data_type: 'bigint'
  is_nullable: 1

=head2 avg_score

  data_type: 'integer'
  is_nullable: 1

=head2 max_score

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "players_id",
  { data_type => "uuid", is_nullable => 1, size => 16 },
  "games",
  { data_type => "bigint", is_nullable => 1 },
  "wins",
  { data_type => "bigint", is_nullable => 1 },
  "losses",
  { data_type => "bigint", is_nullable => 1 },
  "avg_score",
  { data_type => "integer", is_nullable => 1 },
  "max_score",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-01 23:58:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fLpZlBjcWZcZtIoWdB4nOQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

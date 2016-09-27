use utf8;
package Scrabblicious::Schema::Result::Stat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scrabblicious::Schema::Result::Stat

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<Scrabblicious::Schema::BaseResult>

=cut

use base 'Scrabblicious::Schema::BaseResult';

=head1 TABLE: C<stats>

=cut

__PACKAGE__->table("stats");

=head1 ACCESSORS

=head2 stats_id

  data_type: 'uuid'
  default_value: gen_random_uuid()
  is_nullable: 0
  size: 16

=head2 games

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 wins

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 losses

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 avg_score

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 max_score

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 updated

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "stats_id",
  {
    data_type => "uuid",
    default_value => \"gen_random_uuid()",
    is_nullable => 0,
    size => 16,
  },
  "games",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "wins",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "losses",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "avg_score",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "max_score",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "updated",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</stats_id>

=back

=cut

__PACKAGE__->set_primary_key("stats_id");

=head1 RELATIONS

=head2 players

Type: has_many

Related object: L<Scrabblicious::Schema::Result::Player>

=cut

__PACKAGE__->has_many(
  "players",
  "Scrabblicious::Schema::Result::Player",
  { "foreign.stats_id" => "self.stats_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2016-09-27 21:06:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xL/XwNDVcNucsVNIXrPogA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

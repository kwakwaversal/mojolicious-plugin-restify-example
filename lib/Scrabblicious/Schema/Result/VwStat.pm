use utf8;
package Scrabblicious::Schema::Result::VwStat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scrabblicious::Schema::Result::VwStat - Used to help build the stats table.

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<Scrabblicious::Schema::BaseResult>

=cut

use base 'Scrabblicious::Schema::BaseResult';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<vw_stats>

=cut

__PACKAGE__->table("vw_stats");
__PACKAGE__->result_source_instance->view_definition(" SELECT p.players_id,\n    count(*) AS games,\n    sum(\n        CASE\n            WHEN (p.players_id = g.winner_id) THEN 1\n            ELSE 0\n        END) AS wins,\n    sum(\n        CASE\n            WHEN (p.players_id = g.loser_id) THEN 1\n            ELSE 0\n        END) AS losses,\n    (avg(\n        CASE\n            WHEN (p.players_id = g.winner_id) THEN g.winner_score\n            WHEN (p.players_id = g.loser_id) THEN g.loser_score\n            ELSE 0\n        END))::integer AS avg_score,\n    max(\n        CASE\n            WHEN (p.players_id = g.winner_id) THEN g.winner_score\n            WHEN (p.players_id = g.loser_id) THEN g.loser_score\n            ELSE 0\n        END) AS max_score\n   FROM (players p\n     JOIN games g ON (((p.players_id = g.winner_id) OR (p.players_id = g.loser_id))))\n  GROUP BY p.players_id");

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2016-09-27 21:06:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O4YvVm/9m3b6yvCcTfVZ/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

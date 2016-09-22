use utf8;
package Scrabblicious::Schema::Result::Game;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scrabblicious::Schema::Result::Game - Results of all the scrabble games.

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<Scrabblicious::Schema::BaseResult>

=cut

use base 'Scrabblicious::Schema::BaseResult';

=head1 TABLE: C<games>

=cut

__PACKAGE__->table("games");

=head1 ACCESSORS

=head2 games_id

  data_type: 'uuid'
  is_nullable: 0
  size: 16

=head2 winner_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

Home player.

=head2 winner_score

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

Home players score.

=head2 loser_id

  data_type: 'uuid'
  is_foreign_key: 1
  is_nullable: 0
  size: 16

Away player.

=head2 loser_score

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

Away players score.

=head2 started

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

When the game was started.

=head2 finished

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

When the game finished.

=cut

__PACKAGE__->add_columns(
  "games_id",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "winner_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "winner_score",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "loser_id",
  { data_type => "uuid", is_foreign_key => 1, is_nullable => 0, size => 16 },
  "loser_score",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "started",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "finished",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</games_id>

=back

=cut

__PACKAGE__->set_primary_key("games_id");

=head1 RELATIONS

=head2 loser

Type: belongs_to

Related object: L<Scrabblicious::Schema::Result::Player>

=cut

__PACKAGE__->belongs_to(
  "loser",
  "Scrabblicious::Schema::Result::Player",
  { players_id => "loser_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 winner

Type: belongs_to

Related object: L<Scrabblicious::Schema::Result::Player>

=cut

__PACKAGE__->belongs_to(
  "winner",
  "Scrabblicious::Schema::Result::Player",
  { players_id => "winner_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-09-01 14:31:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GNhVrY1oMGtZFq3g0hX64A

__PACKAGE__->uuid_columns('games_id');

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

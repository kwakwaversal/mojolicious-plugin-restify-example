use utf8;
package Scrabblicious::Schema::Result::Player;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Scrabblicious::Schema::Result::Player - Player details (including contact information).

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<Scrabblicious::Schema::BaseResult>

=cut

use base 'Scrabblicious::Schema::BaseResult';

=head1 TABLE: C<players>

=cut

__PACKAGE__->table("players");

=head1 ACCESSORS

=head2 players_id

  data_type: 'uuid'
  is_nullable: 0
  size: 16

Primary key. UUIDs are generally better for futureproofing.

=head2 forename

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

The real forename of the member.

=head2 surname

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

The real surname of the member.

=head2 nickname

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

Everyone likes a pseudonym.

=head2 email

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

We need to be able to contact our members.

=head2 tel_no

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

Contact number for the member (upselling?)

=head2 created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

When the member was created.

=head2 updated

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

When the details were last updated.

=head2 status

  data_type: 'text'
  default_value: 'Active'
  is_nullable: 0
  original: {data_type => "varchar"}

Active, Deleted, Suspended, Trashed.

=cut

__PACKAGE__->add_columns(
  "players_id",
  { data_type => "uuid", is_nullable => 0, size => 16 },
  "forename",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "surname",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "nickname",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "email",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "tel_no",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "created",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "status",
  {
    data_type     => "text",
    default_value => "Active",
    is_nullable   => 0,
    original      => { data_type => "varchar" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</players_id>

=back

=cut

__PACKAGE__->set_primary_key("players_id");

=head1 RELATIONS

=head2 games_losers

Type: has_many

Related object: L<Scrabblicious::Schema::Result::Game>

=cut

__PACKAGE__->has_many(
  "games_losers",
  "Scrabblicious::Schema::Result::Game",
  { "foreign.loser_id" => "self.players_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 games_winners

Type: has_many

Related object: L<Scrabblicious::Schema::Result::Game>

=cut

__PACKAGE__->has_many(
  "games_winners",
  "Scrabblicious::Schema::Result::Game",
  { "foreign.winner_id" => "self.players_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2016-09-22 20:35:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EcYlqcwGxyvAKDRIm9yTcw

__PACKAGE__->belongs_to(
  "vw_scoreboard",
  "Scrabblicious::Schema::Result::VwScoreboard",
  { players_id => "players_id" },
  {
    is_deferrable => 0,
    join_type     => "RIGHT OUTER",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

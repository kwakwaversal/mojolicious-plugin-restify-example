use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Scrabblicious');

subtest 'LIST collection' => sub {
  $t->get_ok('/players')->status_is(200)->content_like(qr/html/);

  $t->get_ok('/players.json')->json_has('/data/0')->json_has('/data/0/id');

  $t->get_ok('/players.json')->json_is('/meta/pager/entries_per_page' => 30);
};

subtest 'READ resource' => sub {
  $t->get_ok('/players/0ca4c5e0-c822-3799-4521-1bf02543e702.json')
    ->status_is(200)
    ->json_is('/data/id' => '0ca4c5e0-c822-3799-4521-1bf02543e702');
};

done_testing();

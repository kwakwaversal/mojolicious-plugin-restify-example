use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Scrabblicious');

subtest 'LIST collection' => sub {
  $t->get_ok('/players')->status_is(200)->content_like(qr/html/);

  $t->get_ok('/players.json')->json_has('/players/0')
    ->json_has('/players/0/id');

  $t->get_ok('/players.json')->json_is('/meta/pager/entries_per_page' => 30);
};

done_testing();

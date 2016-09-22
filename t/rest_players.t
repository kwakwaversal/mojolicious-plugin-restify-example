use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Scrabblicious');

subtest 'LIST collection' => sub {
  $t->get_ok('/players')->status_is(200);

  $t->get_ok('/players.json')->json_has('/players/0');
};

done_testing();

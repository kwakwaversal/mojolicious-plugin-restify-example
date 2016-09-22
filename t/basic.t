use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Scrabblicious');
$t->get_ok('/players')->status_is(200)->content_like(qr/Scrabblicious/i);

done_testing();

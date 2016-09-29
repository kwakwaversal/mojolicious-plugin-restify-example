use Mojo::Base -strict;

BEGIN {
  # Mutes the log output from Mojolicious::Lite
  $ENV{MOJO_LOG_LEVEL} = 'error';
}

use Mojolicious::Lite;
plugin 'Scrabblicious::Plugin::API' =>
  {default_row_limit => 30, maximum_row_limit => 100};

get '/api/page' => sub {
  my $c = shift;
  $c->render(json => {page => $c->api->page, per_page => $c->api->per_page});
};

# Tests the lite app above.

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new;

subtest 'api.page' => sub {
  $t->get_ok("/api/page?page=$_")->json_is('/page' => 1) for (qw/hah -1 0 1/);
  $t->get_ok('/api/page?page=20')->json_is('/page' => 20);
};

done_testing;

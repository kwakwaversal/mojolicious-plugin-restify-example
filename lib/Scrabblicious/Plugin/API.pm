package Scrabblicious::Plugin::API;
use Mojo::Base 'Mojolicious::Plugin';

use Scalar::Util 'looks_like_number';

sub register {
  my ($self, $app, $config) = @_;

  $config //= {};

  $app->helper('api.config' => sub { shift->config->{api} });
  $app->helper(
    'api.page' => sub {
      my $page = shift->param('page');
      return looks_like_number $page && $page > 0 ? $page : 1;
    }
  );
  $app->helper(
    'api.pager' => sub {
      my $c = shift;
      if (@_) {
        return $c->stash->{pager} = shift;
      }
      else {
        return $c->stash->{pager};
      }
    }
  );
  $app->helper(
    'api.per_page' => sub {
      my $c                 = shift;
      my $default_row_limit = $config->{default_row_limit}
        // $c->config->{api}->{default_row_limit};
      my $maximum_row_limit = $config->{maximum_row_limit}
        // $c->config->{api}->{maximum_row_limit};
      my $per_page = $c->param('per_page');
      $per_page
        = (looks_like_number $per_page && $per_page > 0 ? int $per_page : 0)
        || $default_row_limit;
      return $per_page > $maximum_row_limit ? $maximum_row_limit : $per_page;
    }
  );
}

1;

=head1 NAME

Scrabblicious::Plugin::API - API related helpers

=head1 SYNOPSIS

  use Mojolicious::Lite;

  plugin 'Scrabblicious::Plugin::API';

  get '/api/page' => sub {
    my $c = shift;
    $c->render(text => $c->api->page); # 0 or page number
  };

=head1 DESCRIPTION

L<Scrabblicious::Plugin::API> is a collection of API-related helpers for your
REST-based web interface.

=head1 METHODS

L<Scrabblicious::Plugin::API> inherits all methods from L<Mojolicious::Plugin>
and implements the following new ones.

=head2 api->config

  say $c->api->config->{default_row_limit};   # 30

Returns the C<api> configuration C<hashref> from the app's config (which is
importing by L<Mojolicious::Plugin::Config> in L<Scrabblicious>).

=head2 api->page

  my $page = $c->api->page;

Paging - returns the page number (taken from the the C<page> parameter). Returns
1 by default, or 1 if the C<page> parameter value is not a number > 0.

=head2 api->pager

  my $rs = $c->schema->resultset('PLayer')->search({status => 'A'});
  $c->api->pager($rs->pager);

  # get the pager for the active playerrs search (performed above)
  my $pager = $c->api->pager;

Paging - stashes a L<DBIx::Class::ResultSet/pager> in the
L<Mojolicious stash|Mojolicious::Controller/stash> under the key C<meta.pager>.

=head2 api->per_page

  my $per_page = $c->api->per_page;

Paging - returns the amount of rows to be displayed per page (taken from the the
C<per_page> parameter). Returns the C<default_row_limit> api configuration
option if the value is not a number, and C<maximum_row_limit> if the value
exceeds the C<maximum_row_limit>.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut

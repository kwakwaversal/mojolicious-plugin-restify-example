package Scrabblicious::Plugin::Hooks;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
  my ($self, $app, $config) = @_;

  $config //= {};

  # Intercept JSON requests and add more useful information to the output.
  $app->hook(
    before_render => sub {
      my ($c, $args) = @_;

      # If client is requesting JSON, customise the output to suit our needs.
      if ( exists $args->{json}
        && exists $c->stash->{'format'}
        && $c->stash->{'format'} eq 'json')
      {
        $args->{json}->{links}->{self} = $c->url_for->to_abs;

        # Don't expose information if there's an error in the JSON output (the
        # errors hash key is not a Mojo convention).
        if (!$args->{json}->{errors}) {

          # Pager objects have to be explicitly stashed in your controllers.
          if ((my $pager = $c->api->pager)
            && ref $c->api->pager eq 'DBIx::Class::ResultSet::Pager')
          {
            # http://jsonapi.org/format/#fetching-resources
            $args->{json}->{links}->{last}
              = $c->url_for->query(page => $pager->previous_page)->to_abs
              if $pager->previous_page;
            $args->{json}->{links}->{next}
              = $c->url_for->query(page => $pager->next_page)->to_abs
              if $pager->next_page;

            $args->{json}->{meta}->{pager} = {
              current_page     => $pager->current_page,
              entries_per_page => $pager->entries_per_page,
              total_entries    => $pager->total_entries,
              first_page       => $pager->first_page,
              last_page        => $pager->last_page,
              previous_page    => $pager->previous_page,
              next_page        => $pager->next_page,
              first            => $pager->first,
              last             => $pager->last,
            };
          }
        }
      }

      # End hook
    }
  );
}

1;

=head1 NAME

Scrabblicious::Plugin::Hooks - Hook into stuff, yo!

=head1 SYNOPSIS

  use Mojolicious::Lite;

  plugin 'Scrabblicious::Plugin::Hooks';

  get '/players' => sub {
    my $c = shift;

    my $players = $c->db->resultset('Player')->search(
      {'me.status' => {'=' => [qw/Active/]}},
      {
        order_by => {-asc => [qw/me.nickname/]},
        page     => $c->api->page,
        rows     => $c->api->per_page,
      }
    );
    $c->api->pager($players->pager);

    $c->respond_to(
      json => {json => {data => [$players->all]}},
      any  => {
        players  => [$players->all],
        format   => 'html',
        template => 'players/list'
      }
    );
  };

=head1 DESCRIPTION

L<Scrabblicious::Plugin::Hooks> is home to project-specific hooks.

The primary reason this has been created is to hook into C<before_render> to
mangle to the JSON before it is being rendered. Using this technique means we
can also add some extra data to the response to keep it more in line with
L<http://jsonapi.org/>.

=head1 METHODS

L<Scrabblicious::Plugin::Hooks> inherits all methods from L<Mojolicious::Plugin>
and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 HOOKS

=head2 before_render

Intercept JSON requests and add more helpful information to the output.

Specifically checks for the presence of L<Scrabblicious::Plugin::API/pager>
and adds the pager data to the meta property in the JSON output.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut

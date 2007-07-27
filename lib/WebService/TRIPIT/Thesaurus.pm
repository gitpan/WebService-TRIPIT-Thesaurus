package WebService::TRIPIT::Thesaurus;

use strict;
use warnings;

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw/rest xml result/);

use Carp::Clan qw(croak);
use Encode;
use WWW::REST;
use XML::LibXML;

our $API_URI = "http://labs.tripit.jp/api/getrelated";

=head1 NAME

WebService::TRIPIT::Thesaurus - Perl wrapper for Japanese thesaurus search on labs.tripit.jp.

=head1 VERSION

version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

  use WebService::TRIPIT::Thesaurus->new;

  my $service = WebService::TRIPIT::Thesaurus->new;
  my @result = $service->search("foo");
  print join("\n", @result);

=head1 METHODS

=head2 new

=cut

sub new {
    my $class = shift;

    return $class->SUPER::new({
        xml => XML::LibXML->new,
        rest => WWW::REST->new($API_URI),
        result => ''
    });
}

=head2 search($word, [$count, $full])

Search thesaurus by word.
The return value is array or array reference.

$count is limitation results.
$full is full spec result returned as hash references.

=cut

sub search {
    my ($self, $word, $count, $full) = @_;

    $self->rest->dispatch($self->dispatcher($full));

    my @nodes = $self->rest->get(tag => $word, count => $count || '');

    return wantarray ? @nodes : \@nodes;
}

=head2 dispatcher($full)

=cut

sub dispatcher {
    my ($self, $full) = @_;

    return sub {
        my $rest = shift;

        croak($rest->status_line) if ($rest->is_error);

        $self->result($rest->content);

        my $doc = $self->xml->parse_string($self->result);
        my $xc = XML::LibXML::XPathContext->new($doc);
        $xc->registerNs('tripit', 'http://labs.tripit.jp/');

        if ($full) {
            my @nodes = 
                map { { word => encode_utf8($_->textContent), url => $_->getAttribute("url") } } 
                    $xc->findnodes('//tripit:word');
            return @nodes;
        }
        else {
            my @nodes = map { encode_utf8($_->data) } $xc->findnodes('//tripit:word/text()');
            return @nodes;
        }
    };
}

=head1 SEE ALSO

=over 4

=item http://labs.tripit.jp/webapi/

=item L<WWW::REST>

=item L<XML::LibXML>

=back

=head1 AUTHOR

Toru Yamaguchi, C<< <zigorou@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-webservice-tripit-thesaurus@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2007 Toru Yamaguchi, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WebService::TRIPIT::Thesaurus

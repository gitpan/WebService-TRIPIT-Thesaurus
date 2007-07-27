use inc::Module::Install;

name('WebService-TRIPIT-Thesaurus');
author('Toru Yamaguchi <zigorou@cpan.org>');
version_from('lib/WebService/TRIPIT/Thesaurus.pm');
abstract('Perl wrapper for Japanese thesaurus search on labs.tripit.jp.');
license('perl');

requires('Carp::Clan');
requires('Encode');
requires('Class::Accessor::Fast');
requires('WWW::REST');
requires('XML::LibXML', 1.62);

use_test_base;

auto_include;
auto_install;

WriteAll;

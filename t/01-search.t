use Test::More tests => 5;
use WebService::TRIPIT::Thesaurus;

my $service = WebService::TRIPIT::Thesaurus->new;

ok($service);

{
    my @result = $service->search("test", 10);

    ok(@result > 0);
    ok(@result <= 10);
}

{
    my @result = $service->search("test", 10, 1);

    ok($result[0]->{url});
    ok($result[0]->{word});
}


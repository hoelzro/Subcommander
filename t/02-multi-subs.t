use v6;

use Test;
use Subcommander;

plan 2;

my class App does Subcommander::Application {
    multi method foo(Str $) is subcommand {}

    multi method foo(Int $) is subcommand {}

    proto method bar($) is subcommand { * }

    multi method bar(Str $) {}

    multi method bar(Int $) {}
}

my Bool $exception-occurred = False;
my $*ERR = open($*SPEC.devnull, :w);

try {
    App.new.run(['foo']);
    CATCH { default { $exception-occurred = True } }
}

ok($exception-occurred, 'An exception should occur for subcommands with multiple candidates');

$exception-occurred = False;

try {
    App.new.run(['bar']);
    CATCH { default { $exception-occurred = True } }
}

ok($exception-occurred, 'An exception should occur for subcommands with multiple candidates');

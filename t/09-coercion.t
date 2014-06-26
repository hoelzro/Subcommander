use v6;
use Test;
use App::Subcommander;

my $prev-value;

sub reset {
    $prev-value = Int;
}

my class App does App::Subcommander {
    method coercing(Str $value as Int) is subcommand {
        $prev-value = $value;
    }
}

plan 1;

App.new.run(['coercing', '10']);

ok $prev-value eqv 10, 'type coercion should be unaffected';

use v6;
use Test;

use Subcommander;

plan 1;

my class CustomException is Exception {
}

my class App does Subcommander::Application {
    method exceptional is subcommand {
        CustomException.new.throw;
    }
}

my $*ERR = open($*SPEC.devnull, :w);

throws_like({
    App.new.run(['exceptional']);
}, CustomException);

use v6;
use Test;
use IO::String;
use Subcommander;

plan 4;

skip_rest 'Module:ver<*> NYI';

sub collect-output($app, &block) {
    my $*OUT = IO::String.new;

    &block($app);

    ~$*OUT
}

my $showed-help;

my class App:ver<0.0.1> does Subcommander::Application {
    method foo is subcommand {}

    method show-help {
        $showed-help = True;
    }
}

my $version = collect-output(App.new, {
    $^app.run(['version'])
});

$version .= chomp;

# skipped
#is $version, '0.0.1';
#ok !$showed-help;

$showed-help = False;
$version = collect-output(App.new, {
    $^app.run(['--version'])
});

$version .= chomp;

# skipped
#is $version, '0.0.1';
#ok !$showed-help;

done;

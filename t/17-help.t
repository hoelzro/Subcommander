use v6;
use Test;
use Subcommander;
use IO::String;

sub collect-help($app, &action) {
    my $*ERR = IO::String.new;

    &action($app);

    return ~$*ERR;
}

# XXX class comment?
my class App does Subcommander::Application {
    #| Does good things.  They may come to you if you wait!
    #| Batteries not included.
    method good-cmd(
        #| The thing to do good things to
        Str $target,
        #| Something optional
        Str :$option1,
        #| Something else optional
        Int :$option2
    ) is subcommand
    {
    }
}

plan *;

my $*PROGRAM_NAME = 'App';

my $TOP_LEVEL_HELP = qq:to/END_HELP/;
Usage: App [command]

good-cmd	Does good things.
END_HELP

my $help;

$help = collect-help(App.new, {
    $^app.run([]);
});

is $help, $TOP_LEVEL_HELP;

$help = collect-help(App.new, {
    $^app.run(['--help']);
});

is $help, $TOP_LEVEL_HELP;

done;

# non-existing command
# non-existing option (app and command)
# bad parse for option
# no command provided
# --help, -h
# --help vs --help-commands?
# help command
# -?
# --version, -v
# version command
# does --help/help command run app option accessors?

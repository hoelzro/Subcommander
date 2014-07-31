use v6;
use Test;
use Subcommander;
use IO::String;

sub collect-help($app, &action) {
    my $*ERR = IO::String.new;

    &action($app);

    return ~$*ERR;
}

sub with-message($message, $help) {
    $message ~ "\n" ~ $help
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

    #| Requires a value
    method has-required-param(
        #| Requires a value
        Str :$param!
    ) is subcommand {}

    method not-a-command {}
}

plan *;

my $*PROGRAM_NAME = 'App';

my $TOP_LEVEL_HELP = qq:to/END_HELP/;
Usage: App [command]

          good-cmd	Does good things.
has-required-param	Requires a value
              help	Display help to the user
END_HELP

my $GOOD_CMD_HELP = qq:to/END_HELP/;
Usage: App good-cmd [options] target

Options:

--option1	Something optional
--option2	Something else optional
END_HELP

my $REQUIRED_PARAM_HELP = qq:to/END_HELP/;
Usage: App has-required-param [options]

Options:

--param	Requires a value
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

$help = collect-help(App.new, {
    $^app.run(['help', 'good-cmd']);
});

is $help, $GOOD_CMD_HELP;

$help = collect-help(App.new, {
    $^app.run(['good-cmd', '--help']);
});

is $help, $GOOD_CMD_HELP;

$help = collect-help(App.new, {
    $^app.run(['has-required-param']);
});

is $help, with-message("Required option 'param' not provided", $REQUIRED_PARAM_HELP);

$help = collect-help(App.new, {
    $^app.run(['no-such-command']);
});

is $help, with-message("No such command 'no-such-command'", $TOP_LEVEL_HELP);

$help = collect-help(App.new, {
    $^app.run(['--unknown-option', 'with-value', 'good-cmd', 'nothing']);
});

is $help, with-message("Unrecognized option 'unknown-option'", $TOP_LEVEL_HELP);

$help = collect-help(App.new, {
    $^app.run(['--unknown-option', '--interactive', 'good-cmd', 'nothing']);
});

is $help, with-message("Unrecognized option 'unknown-option'", $TOP_LEVEL_HELP);

$help = collect-help(App.new, {
    $^app.run(['good-cmd', '--unknown-option', 'with-value', 'nothing']);
});

is $help, with-message("Unrecognized option 'unknown-option'", $GOOD_CMD_HELP);

$help = collect-help(App.new, {
    $^app.run(['good-cmd', '--unknown-option', '--interactive', 'nothing']);
});

is $help, with-message("Unrecognized option 'unknown-option'", $GOOD_CMD_HELP);

$help = collect-help(App.new, {
    $^app.run(['good-cmd', '--option2=foo', 'nothing']);
});

is $help, with-message("Failed to convert 'foo' to Int", $GOOD_CMD_HELP);

done;

# --help vs --help-commands?
# -?
# --version, -v
# version command
# does --help/help command run app option accessors?
# Insert app comment/command comment before options/targets
# app options
# help $bad-cmd
# command/option aliases
# basically, every feature I've added so far
# Describe positional arguments before options

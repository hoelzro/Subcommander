use v6;
use Test;
use Subcommander;

my class App does Subcommander::Application {
    has $.attr is option;
    has $!hidden;
    has Bool $.flag is option = False;
    has Int $.inty is option;
    has @.listy is option;
    has $.bad-name is option('good-name');
    has $!bad-hidden-name;

    has $.prev-opt is rw;
    has $.prev-arg is rw;
    has $.showed-help is rw = False;

    method hidden { $!hidden }

    method attr-alias is option {
        return-rw $!attr
    }

    method rw-method is option {
        return-rw $!hidden
    }

    method listy-alias is option {
        return-rw @!listy
    }

    method bad-hidden-name is option('good-hidden-name') {
        return-rw $!bad-hidden-name
    }

    method good-hidden-name { $!bad-hidden-name }

    method cmd(Str :$opt) is subcommand {
        $.prev-opt = $opt;
    }

    method argh(Str $arg?) is subcommand {
        $.prev-arg = $arg;
    }

    method show-help($?) {
        $.showed-help = True;
    }

    method dont-call-me {
        die "You shouldn't call me!";
    }
}

plan *;

my $*ERR = open($*SPEC.devnull, :w);

my $app;

$app = App.new;
$app.run(['cmd']);
ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.flag;
ok !$app.hidden.defined;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--attr', 'foo', 'cmd']);

ok !$app.showed-help;
is $app.attr, 'foo';
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--attr', 'foo', '--rw-method', 'bar', 'cmd']);

ok !$app.showed-help;
is $app.attr, 'foo';
is $app.hidden, 'bar';
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--rw-method', 'bar', 'cmd', '--opt', 'value']);

ok !$app.showed-help;
ok !$app.attr.defined;
is $app.hidden, 'bar';
ok !$app.flag;
ok !$app.inty.defined;
is $app.prev-opt, 'value';
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--flag', 'argh', 'arg']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok $app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
is $app.prev-arg, 'arg';
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--inty', '10', 'argh', 'arg']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok $app.inty eqv 10;
ok !$app.prev-opt.defined;
is $app.prev-arg, 'arg';
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--inty', 'foo', 'argh', 'arg']);

ok $app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--flag', '--inty', 'foo', 'argh', 'arg']);

ok $app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok $app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--inty', 'foo', '--flag', 'argh', 'arg']);

ok $app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--attr-alias', 'foo', 'cmd']);

ok !$app.showed-help;
is $app.attr, 'foo';
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--attr-alias', 'foo', '--attr', 'bar', 'cmd']);

ok !$app.showed-help;
is $app.attr, 'bar';
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--listy', 'foo', 'cmd']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, ['foo'];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--listy', 'foo', '--listy', 'bar', 'cmd']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [<foo bar>];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--listy', 'foo', '--listy-alias', 'bar', 'cmd']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [<foo bar>];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--unknown', 'foo', 'cmd']);

ok $app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--dont-call-me', 'foo', 'cmd']);

ok $app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--good-name', 'foo', 'cmd']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
is $app.bad-name, 'foo';
ok !$app.good-hidden-name.defined;

$app = App.new;
$app.run(['--good-hidden-name', 'bar', 'cmd']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok !$app.flag;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
is $app.good-hidden-name, 'bar';

$app = App.new;
$app.flag = True;
$app.run(['--noflag', 'cmd']);

ok !$app.showed-help;
ok !$app.attr.defined;
ok !$app.hidden.defined;
ok $app.flag eqv False;
ok !$app.inty.defined;
ok !$app.prev-opt.defined;
ok !$app.prev-arg.defined;
is-deeply $app.listy, [];
ok !$app.bad-name.defined;
ok !$app.good-hidden-name.defined;

done();

# XXX try conflicting with command options
# XXX slurpy options?

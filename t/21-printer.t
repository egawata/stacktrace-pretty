use strict;
use warnings;
use utf8;

use lib qw(lib);

use Test::More;

BEGIN {
    use_ok 'StackTrace::Pretty::Printer';
}

subtest '_extract_func_and_line_num' => sub {
    subtest 'first line' => sub {
        my $line = 'Message at lib/Some/Module.pm line 100.';
        my $ret = StackTrace::Pretty::Printer->_extract_func_and_line_num($line);
        is_deeply $ret, {
            dest_func => undef,
            filename => 'lib/Some/Module.pm',
            lineno => '100',
        };
    };

    subtest 'child line' => sub {
        my $line = '    Some::Module::dest called at lib/Another/Module.pm line 200';
        my $ret = StackTrace::Pretty::Printer->_extract_func_and_line_num($line);
        is_deeply $ret, {
            dest_func => 'Some::Module::dest',
            filename => 'lib/Another/Module.pm',
            lineno => '200',
        };
    };
};

done_testing;

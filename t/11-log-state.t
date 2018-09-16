use strict;
use warnings;
use utf8;
use lib qw(lib);

use Test::More;

my $FIRST_LINE_STACK_TRACE = 'Message at Some::Module::function line 100.';
my $CHILD_LINE_STACK_TRACE = '    Some::Module::dest called at Another::Module::src line 200';

BEGIN {
    use_ok 'StackTrace::Pretty::LogState';
}

subtest 'not in stack trace' => sub {
    subtest 'Previous is in stack trace' => sub {
        my $ls = StackTrace::Pretty::LogState->new();

        $ls->{_is_in_stack_trace} = 0;
        $ls->{_has_done_prev_stack_trace} = 0;

        $ls->read('Normal Text');
        is $ls->is_in_stack_trace, 0, 'is_in_stack_trace';
        is $ls->has_done_prev_stack_trace, 0, 'has_done_prev_stack_trace';
    };

    subtest 'Previous is in another stack trace' => sub {
        my $ls = StackTrace::Pretty::LogState->new();

        $ls->{_is_in_stack_trace} = 1;
        $ls->{_has_done_prev_stack_trace} = 0;

        $ls->read('Normal Text');
        is $ls->is_in_stack_trace, 0, 'is_in_stack_trace';
        is $ls->has_done_prev_stack_trace, 1, 'has_done_prev_stack_trace';
    };
};

subtest 'Start a stack trace' => sub {
    subtest 'Previous is not in stack trace' => sub {
        my $ls = StackTrace::Pretty::LogState->new();

        $ls->{_is_in_stack_trace} = 0;
        $ls->{_has_done_prev_stack_trace} = 0;

        $ls->read($FIRST_LINE_STACK_TRACE);
        is $ls->is_in_stack_trace, 1, 'is_in_stack_trace';
        is $ls->has_done_prev_stack_trace, 0, 'has_done_prev_stack_trace';
    };

    subtest 'Previous is in another stack trace' => sub {
        my $ls = StackTrace::Pretty::LogState->new();

        $ls->{_is_in_stack_trace} = 1;
        $ls->{_has_done_prev_stack_trace} = 0;

        $ls->read($FIRST_LINE_STACK_TRACE);
        is $ls->is_in_stack_trace, 1, 'is_in_stack_trace';
        is $ls->has_done_prev_stack_trace, 1, 'has_done_prev_stack_trace';
    };
};

subtest 'Child stack trace' => sub {
    subtest 'Previous is not in stack trace (abnormal case)' => sub {
        my $ls = StackTrace::Pretty::LogState->new();

        $ls->{_is_in_stack_trace} = 0;
        $ls->{_has_done_prev_stack_trace} = 0;

        $ls->read($CHILD_LINE_STACK_TRACE);

        # If previous line is not in stack trace,
        # this line shouldn't be considered as child line of stack trace.
        is $ls->is_in_stack_trace, 0, 'is_in_stack_trace';
        is $ls->has_done_prev_stack_trace, 0, 'has_done_prev_stack_trace';
    };

    subtest 'Previous is in another stack trace' => sub {
        my $ls = StackTrace::Pretty::LogState->new();

        $ls->{_is_in_stack_trace} = 1;
        $ls->{_has_done_prev_stack_trace} = 0;

        $ls->read($CHILD_LINE_STACK_TRACE);
        is $ls->is_in_stack_trace, 1, 'is_in_stack_trace';
        is $ls->has_done_prev_stack_trace, 0, 'has_done_prev_stack_trace';
    };
};

done_testing;

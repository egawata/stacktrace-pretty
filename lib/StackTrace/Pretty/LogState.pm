package StackTrace::Pretty::LogState;
use strict;
use warnings;
use utf8;

my $FIRST_LINE_ST_PATTERN = qr/^\S+ at \S+ line \d+\.$/;
my $CHILD_LINE_ST_PATTERN = qr/^\s+\S+ called at \S+ line \d+$/;

sub new {
    my ($class) = @_;

    return bless {
        _is_in_stack_trace => 0,
        _has_done_prev_stack_trace => 0,
        _line_num => 0,
    }, $class;
}

sub read {
    my ($self, $line) = @_;

    if ($line =~ $FIRST_LINE_ST_PATTERN) {
        $self->{_has_done_prev_stack_trace} = ($self->{_is_in_stack_trace}) ? 1 : 0;
        $self->{_is_in_stack_trace} = 1;
        $self->{_line_num} = 0; # Reset
    }
    elsif ($line =~ $CHILD_LINE_ST_PATTERN) {
        if ($self->{_is_in_stack_trace}) {
            $self->{_is_in_stack_trace} = 1;    #  Unchanged
            $self->{_line_num}++;
        }
        else {  # Abnormal case
            $self->{_is_in_stack_trace} = 0;
        }
        $self->{_has_done_prev_stack_trace} = 0;
    }
    else {  # Normal line
        $self->{_has_done_prev_stack_trace} = ($self->{_is_in_stack_trace}) ? 1 : 0;
        $self->{_is_in_stack_trace} = 0;
        $self->{_line_num} = 0;
    }

}

sub is_in_stack_trace {
    my ($self) = @_;

    return $self->{_is_in_stack_trace};
}

sub has_done_prev_stack_trace {
    my ($self) = @_;

    return $self->{_has_done_prev_stack_trace};
}

sub line_num {
    my ($self) = @_;

    return $self->{_line_num};
}

1;

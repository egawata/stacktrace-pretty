package StackTrace::Pretty::Printer;
use strict;
use warnings;
use utf8;

our $COLOR_RAW_LINE = "\e[38;5;193m\e[48;5;130m";
our $COLOR_LINENUM = "\e[38;5;239m";
our $COLOR_NORMAL_LINE = "\e[38;5;242m";
our $COLOR_CURRENT_LINE = "\e[38;5;230m\e[48;5;234m";
our $COLOR_RESET = "\e[0m";


sub new {
    my ($class, @args) = @_;
    my $args = (ref $args[0] eq 'HASH') ? $args[0] : { @args };

    bless $args, $class;
}

sub print {
    my ($self, @args) = @_;
    my $args = (ref $args[0] eq 'HASH') ? $args[0] : { @args };

    my $filename = $args->{filename} or die "'filename' required";
    my $lineno = $args->{lineno} or die "'lineno' required";
    my $raw = $args->{raw} or die "'raw' required";

    my $num_lines_context = $args->{num_lines_context} // 2;

    my $print_start = $lineno - $num_lines_context;
    if ($print_start < 1) {
        $print_start = 1;
    }
    my $print_end = $lineno + $num_lines_context;
    my $line_num_area_width = length $print_end;

    open my $IN, '<', $filename or die $!;

    <$IN> for (1 .. $print_start - 1);

    print "${COLOR_RAW_LINE}${raw}${COLOR_RESET}\n";
    print "----------------------------------------------------\n";
    for my $current_line_no ($print_start .. $print_end) {
        my $line = <$IN>;
        if (not $line) {
            last;
        }
        chomp($line);

        my $color_highlight_code = ($lineno == $current_line_no) ? $COLOR_CURRENT_LINE : $COLOR_NORMAL_LINE;
        print sprintf(
            "${COLOR_LINENUM}%${line_num_area_width}d:${COLOR_RESET} "
            . "${color_highlight_code}%s${COLOR_RESET}"
            . "\n",
            $current_line_no,
            $line
        );
    }
    print "----------------------------------------------------\n";

    close $IN;
}


1;

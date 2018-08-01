#!/usr/bin/perl -w

use Doc::Kadoc;
use Doc::Kadoc::Josef;

use strict;
use warnings;
use 5.010;
use Data::Dumper;

use Getopt::Std;
$Getopt::Std::STANDARD_HELP_VERSION = 1;

use constant HEADER => "===============================\n            KADOC           \n===============================\n\n";

my %options=();
getopts("hvo:", \%options);

if ( $options{h} )
{
    print HEADER;
    print "KADOC is a Karel documentation gernator.";
    print "\n";
}

if ( $options{v} ){
    print HEADER;
    print "VERSION: ", $Doc::Kadoc::VERSION, "\n";
}

my $output_file = "";
if ( $options{o} ) {
    $output_file = $options{o};
}

my $inputfile = "";
if( defined $ARGV[0]) {
    $inputfile = $ARGV[0];
}else{
    print "where is the input karel script!!!\n";
    exit( 0 );
}

#
# start building kadoc

# open the input file
open FILE, $inputfile or die $!;
# copy the lines into an array
my @lines = <FILE>;
# close the file
close( FILE );

my @routines;
my %program;

# go through each line
for ( my $i = 0; $i < scalar( @lines ); $i++ )
{
    my $line = $lines[$i];

    # remove all leading spaces
    $line =~ s/^[\t\s]+//;

    # remove mutiple inner spaces
    $line =~ s/[\t\s]+/ /;

    # find a routine documentation
    if ( $line =~ /^routine ([\d\w]+)/i ){
        my $routine_name = $1;
        my $comments = '';
        for( my $n = $i - 1; $n > 0; $n-- ) {
            if( $lines[$n] =~ /\-\-[\w\d\s\t]*/ ) {
                # Becase we're now reading backwards,
                # we need to prepend
                $comments = $lines[$n] . $comments;
            } else {
                # Exit and continue
                $n = 0;
            }
        }
        push @routines, Doc::Kadoc::Josef::routine( $routine_name, $comments);
    }
    # find the program tag
    if ( $line =~ /^program ([\d\w]+)/i ){
        my $program_name = $1;
        my $comments = '';
        for( my $n = $i - 1; $n >= 0; $n-- ) {
            if( $lines[$n] =~ /\-\-[\w\d\s\t]*/ ) {
                # Becase we're now reading backwards,
                # we need to prepend
                $comments = $lines[$n] . $comments;
            } else {
                # Exit and continue
                $n = 0;
            }
        }
        %program = Doc::Kadoc::Josef::program ( $program_name, $comments);
    }

}


# after having colleectred all data
use Template;

my %ttopt = (INCLUDE_PATH => './template',
               OUTPUT_PATH  => './bin');

my $tt = Template->new(\%ttopt);

my @prog_authors = @{ $program{"authors"} };
my @prog_todos = @{ $program{"todos"} };
my @ttroutines;

## build routine
for (my $i = 0; $i <= $#routines; $i++) {
    my %tmp = %{ $routines[$i] };
    my %tmp_ret = %{ $tmp{"return"} };
    my @tmp_authors = @{ $tmp{"authors"} };
    my @tmp_todo = @{ $tmp{"todos"} };
    my @tmp_params = @{ $tmp{"params"} };

    push @ttroutines, {
        title => $tmp{"title"},
        brief => $tmp{"brief"},
        description => $tmp{"discription"},
        date => $tmp{"date"},
        ret => { datatype => $tmp_ret{"datatype"},
                 datavalue => $tmp_ret{"datavalue"}, },
        authors => \@tmp_authors,
        params => \@tmp_params,
        todos => \@tmp_todo,
    };
}

my %ttvars = (
    title        => $program{"title"},
    brief        => $program{"brief"},
    todos        => \@prog_todos,
    comment      => $program{"discription"},
    license      => $program{"license"},
    file_name    => $program{"filename"},
    authors      => \@prog_authors,
    copyright    => $program{"copyright"},
    date         => $program{"date"},
    first_author => $prog_authors[0],
    routines     => \@ttroutines,);

$tt->process("index.tt", \%ttvars) or die $tt->error;

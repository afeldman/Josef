#!/usr/bin/perl -w

use Doc::Kadoc;
use Doc::Kadoc::Josef;

use strict;
use warnings;
use 5.010;
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
        Doc::Kadoc::Josef::routine ( $routine_name, $comments)
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
        #say $comments;
    }

}

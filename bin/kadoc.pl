#!/usr/bin/perl -w

use strict;
use warnings;
use 5.010;
use Getopt::Std;
$Getopt::Std::STANDARD_HELP_VERSION = 1;

use constant VERSION => '0.0.1';
use constant HEADER => "===============================\n            KADOC           \n===============================\n\n";
    
my %options=();
getopts("hvo:", \%options);

if ( $options{h} )
{
    print HEADER;
    print "KADOC is a Karel documentation gernator.";
    print 
    print "\n";
}

if ( $options{v} ){
    print HEADER;
    print "VERSION: ",VERSION,"\n";
}

my $output_file = "";
if ( $options{o} ) {
    $output_file = $options{o};
}

my $inputfile = "";
if( defined $ARGV[0]) {
    $inputfile = $ARGV[0]
}else{
    print "where is the input karel script!!!\n"
}


#
# start building kadoc

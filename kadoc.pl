#!/usr/bin/env perl

use warnings;
use strict;

if( scalar( @ARGV ) < 1 ) {
    print "\nPlease specify a file to parse.\n\n";
    exit( 0 );
}

main( @ARGV );

sub main {
    my $path = $_[0];
    
    # Open our file and do some science!
    open FILE, $path or die $!;
    my @lines = <FILE>;
    close( FILE );
    
    my @subs;
    my $body = '';
    
    for( my $i = 0; $i < scalar( @lines ); $i++ ) {
	my $line = $lines[$i];
	
	# Remove leading spaces
	$line =~ s/^[\t\s]+//;
	
	# Remove  multiple inner space
	$line =~ s/[\t\s]+/ /;
	
	if( $line =~ /^routine ([\d\w_-]+)$/i ) {
	    my $h2 = "<h2 style=\"margin:0px; padding:0px; display:inline; font-size:1.2em; color:#444;\">";
	    $body .= '<br />' . $h2 . $1 . "()</h2>\n";
	    
	    # We've found one!
	    my $comments = '';
	    
	    # Now we go backwards, nabbing the comments as we go
	    for( my $n = $i - 1; $n > 0; $n-- ) {
		if( $lines[$n] =~ /--[\w\d\s\t]*/ ) {
		    # Because we're now reading backwards,
		    # we need to prepend
		    $comments = lineToHtml( $lines[$n] ) . $comments;
		} else {
		    # Exit and continue
		    $n = 0;
		}
	    }
	    
	    my $pStyle = "<p style=\"display:block; background-color:#eee; margin:0px;";
	    $pStyle .= "padding:5px; border:1px dashed #aaa; width:90%; font-size:9pt;\">";
	    $comments = $pStyle . $comments . "</p>\n";
	    $body .= $comments;
	}
    } #elsif ( $line =~ /^program ([\d\w_-]+)$/i ) {}
    $body .= "\n\n";
    print bodyToHtml( $body );
    exit( 0 );
}

sub bodyToHtml {
    my $body = $_[0];
    my $bodyHeader = '<!DOCTYPE html />';
    $bodyHeader .= '<html><head>';
    $bodyHeader .= '</head><body style="font-family:sans-serif;">';
    
    my $bodyFooter = '</body></html>';
    return $bodyHeader . $body . $bodyFooter;
}

sub lineToHtml {
    my $line = $_[0];
    
    my $formatted = $line;
    $formatted =~ s/^[--\s\t]+//;
    $formatted =~ s/\n+//;
    if( $formatted =~ /^\@param/ ) {
	$formatted =~ s/\@param/<strong>\@param<\/strong>/;
	$formatted = '<br /><span style="display:block; color:#499;">' . $formatted . '</span>';
    } elsif( $formatted =~ /^\@return/ ) {
	$formatted =~ s/\@return/<strong>\@return<\/strong>/;
	$formatted = '<br /><span style="display:block; color:#494; margin-top:10px;">' . $formatted . '</span>';
    } elsif ( $formatted =~ /^\@brief/ ) {
	$formatted =~ s/\@brief/<strong>\@brief<\/strong>/;
	$formatted =~ '<br /><span style="display:block; color:#220; font-style:bold;">' . $formatted . '</span>'
    }

    
    $formatted =~ s/ (integer|array|string|boolean|byte|real) / <span style="color:#949; font-style:italic;">$1<\/span> /i;
    $formatted .= "\n";
    return $formatted;
}

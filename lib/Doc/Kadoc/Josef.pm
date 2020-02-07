package Doc::Kadoc::Josef;

use warnings;
use strict;

#todo: day time

#datatype string|integer|array|boolean|byte|real

use Exporter qw( import );
our @EXPORT_OK = qw( parser );

sub normaize_text{
    my $comment = $_[0];

    $comment =~ s/\-\-[\t\s]*//g;
    $comment =~ s/\n[\t\s]+/\n/g;

    return $comment;
}

sub parse_brief{
    my $line = $_[0];
    my $brief = "";

    if ( $line =~ /^\@brief[\t\s]*([\w\s\t\d]*)/i){
        if ( $1 ) {
            $brief = $1;
        }else{
            $brief = "brief without description?";
        }
    }

    return $brief;
}

sub parse_date{
    my $line = $_[0];

    $line =~ s/\@date[\t\s]*//i;
    my $date = $line; # calculate time

    return $date;
}

sub parse_author{
    my $line = $_[0];
    $line =~ s/\@author[\t\s]*//i;
    return $line;
}

sub parse_todo{
    my $line = $_[0];
    $line =~ s/\@todo[\t\s]*//i;

    return $line;
}

sub routine {
    my ($title, $comment) = @_;

    my $brief   = '';
    my $desc    = '';
    my $date    = '';# change to date
    my @authors;
    my @params;
    my @todos;
    my %ret     = ("datatype" => "",
                   "datavalue" => "",);

    $comment = normaize_text($comment);
    my @form_comment = split /\n/, $comment;

    for my $line (@form_comment)
    {

        if ( $line =~ /^\@param[\t\s]*([string|integer|array|boolean|byte|real]+)([\w\s\t\d]*)/i ){
            my %param_tmp = (datatype => "",
                             datavalue => "",);
            if ( $1 ) {
                $param_tmp{datatype} = $1;
            }
            if ( $2 ) {
                $param_tmp{datavalue} = $2;
            }

            push @params, \%param_tmp;

        } elsif ( $line =~ /^\@return[\t\s]*([string|integer|array|boolean|byte|real]+)([\w\s\t\d]*)/i ){
            if ( !$1 ){
                $ret{"datatype"}= "";
                $ret{"datavalue"}= "no return ratatype!";
            }else {
                if ( $2 ){
                    $ret{"datatype"}= $1;
                    $ret{"datavalue"}= $2;
                }else {
                    $ret{"datatype"}= $1;
                    $ret{"datavalue"}= "";
                }
            }
        } elsif ( $line =~ /^\@brief/i){
            $brief = parse_brief($line);
        } elsif ( $line =~ /^\@date/i) {
            $date = parse_date($line);
        } elsif ( $line =~ /^\@author/i) {
            push @authors, parse_author($line);
        } elsif ( $line =~ /^\@todo/i) {
            push @todos, parse_todo($line);
        } else {
            $desc .= $line . " ";
        }

    }

    return {
        "title"       => $title,
        "brief"       => $brief,
        "discription" => $desc,
        "return"      => \%ret,
        "date"        => $date,
        "params"      => \@params,
        "authors"     => \@authors,
        "todos"       => \@todos,
        };
}

sub program {
    my ($title, $comment) = @_;

    my $brief     = '';
    my $desc      = '';
    my $date      = '';# change to date
    my $license   = '';
    my $file_name = '';
    my $copyright = '';
    my @authors;
    my @todos;

    $comment = normaize_text($comment);
    my @form_comment = split /\n/, $comment;

    for my $line (@form_comment)
    {
        if ( $line =~ /^\@brief/i){
            $brief = parse_brief($line);
        } elsif ( $line =~ /^\@date/i) {
            $date = parse_date($line);
        } elsif ( $line =~ /^\@author/i) {
            push @authors, parse_author($line);
        } elsif ( $line =~ /^\@file/i) {
            $line =~ s/\@file[\t\s]*//i;
            $file_name = $line;
        } elsif ( $line =~ /^\@copyright/i) {
            $line =~ s/\@copyright[\t\s]*//i;
            $copyright = $line;
        } elsif ( $line =~ /\@todo/i) {
            push @todos, parse_todo($line);
        } elsif ( $line =~ /^\@license/i) {
            $line =~ s/\@license[\t\s]*//i;
            $license = $line;
        } else {
            $desc .= $line . " ";
        }
    }

    return (
        "title"       => $title,
        "brief"       => $brief,
        "discription" => $desc,
        "date"        => $date,
        "license"     => $license,
        "filename"    => $file_name,
        "authors"     => \@authors,
        "todos"       => \@todos,
        "copyright"   => $copyright,
        );
}

sub parser{
    my @lines = @_;

    my @routines;
    my %program;

    # go through each line
    for ( my $i = 0; $i < scalar( @lines ); $i++ ){
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
            push @routines, routine( $routine_name, $comments );
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
            %program = program ( $program_name, $comments);
        }

    }

    return (\@routines,\%program);
}

1;

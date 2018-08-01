package Doc::Kadoc::Josef;

use warnings;
use strict;
use 5.010;
use Data::Dumper;

#datatype string|integer|array|boolean|byte|real

use Exporter qw( import );
our @EXPORT_OK = qw( routine );

sub parse_brief{}
sub parse_author{}
sub parse_date{}

sub routine {
    my ($title, $comment) = @_;

    my $brief = '';
    my $desc  = '';
    my $ret   = '';
    my $date;
    my @authors;
    my @params;

    $comment =~ s/\-\-[\t\s]*//g;
    my @form_comment = split /\n/, $comment;

    for my $line (@form_comment)
    {

        if ( $line =~ /^\@param[\t\s]*([string|integer|array|boolean|byte|real]+)([\w\s\t\d]*)/i ){
            my %param_tmp;
            $param_tmp{"datatype"} = $1
            $param_tmp{"datavalue"} = $2
            #push @{ $param_tmp{$_} }, $+{$_} for keys %+;

            #push @params, \%param;

            print Dumper \%param_tmp;

            #say %param{'datatype'}

        }elsif ( $line =~ /^\@return/ ){
            say " ";
        }

    }

    print Dumper @params;


    #for my %elem (@params){
    #    say %elem{"datatype"};
    #}

    my %routine_hash = (
        "title"       => $title,
        "brief"       => $brief,
        "discription" => $desc,
        "return"      => $ret,
        "date"        => $date,
        "params"      => @params,
        "authors"     => @authors,
    );

    return \%routine_hash;
}

sub program {

}

1;

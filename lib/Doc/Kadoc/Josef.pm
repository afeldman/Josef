package Doc::Kadoc::Josef;

use warnings;
use strict;
use 5.010;
use Data::Dumper;

#datatype string|integer|array|boolean|byte|real

use Exporter qw( import );
our @EXPORT_OK = qw( routine );

sub parse_brief{
    my $line = @_[0];
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
            my %param_tmp = (
                "datatype" => "",
                "datavalue" => "",
                );
            if ( $1 ) {
                $param_tmp{"datatype"} = $1;
            }
            if ( $2 ) {
                $param_tmp{"datavalue"} = $2;
            }

            push @params, \%param_tmp;

        } elsif ( $line =~ /^\@return[\t\s]*([string|integer|array|boolean|byte|real]+)([\w\s\t\d]*)/i ){
            if ( !$1 ){
                $ret = {"datatype", "", "datavalue", "no return ratatype!"};
            }else {
                if ( $2 ){
                    $ret = {"datatype", $1, "datavalue", $2};
                }else {
                    $ret = {"datatype", $1, "datavalue", ""};
                }
            }
        } elsif ( $line =~ /^\@brief/i){
            $brief = parse_brief($line);
            say $brief;
        } elsif {

        } else {

        }

    }

    #   for my $elem (@params){
    #       for my $key ( keys %$elem ){
    #           my $value = %$elem{$key};
    #           say "$key has value: $value";
    #       }
    #   }

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

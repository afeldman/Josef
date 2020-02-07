use strict;
use warnings;
use 5.008;
use inc::Module::Install 1.00;

use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
my %MM_ARGS = (
    NAME              => 'Doc::Kadoc',
    VERSION_FROM      => 'lib/Doc/Kadoc.pm', # finds $VERSION
    PREREQ_PM         => {
	'Template::Toolkit' => 2.24,
    },
    TEST_REQUIRES => {
      'Test::Spec'    => 0.53,
    },
    ABSTRACT_FROM  => 'lib/Doc/Kadoc.pm', # retrieve abstract from module
    AUTHOR         => 'Anton Feldmann <anton.feldmann@gmail.com>',
    LICENSE => 'mit',
    META_MERGE        => {
        'meta-spec' => { version => 2.0 },
        resources => {
            repository => {
                type => 'git',
                web => 'https://github.com/afeldman/Josef',
                url => 'https://github.com/afeldman/Josef',
            },
            bugtracker => {
                web => 'https://github.com/afeldman/Josef/issues',
            },
        },
    },
);

$MM_ARGS{BUILD_REQUIRES} = {%{$MM_ARGS{BUILD_REQUIRES}}, %{delete $MM_ARGS{TEST_REQUIRES}}}
  if $eumm_version < 6.63_03;
$MM_ARGS{PREREQ_PM} = {%{$MM_ARGS{PREREQ_PM}}, %{delete $MM_ARGS{BUILD_REQUIRES}}}
  if $eumm_version < 6.55_01;

all_from 'lib/Doc/Kadoc.pm';

install_script 'bin/kadoc.pl';

WriteMakefile(%MM_ARGS);

use 5.008005;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
my %MM_ARGS = (
    NAME              => 'Doc::KADOC',
    VERSION_FROM      => 'lib/Doc/kadoc.pm', # finds $VERSION
    PREREQ_PM         => {
      'Template::Toolkit' => 0,
    },
    TEST_REQUIRES => {
      'Test::Spec'    => 0,
    },
    ABSTRACT_FROM  => 'lib/Doc/kadoc.pm', # retrieve abstract from module
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
WriteMakefile(%MM_ARGS);

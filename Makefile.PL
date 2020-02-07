use strict;
use warnings;
use 5.008;
use inc::Module::Install 1.00;

name 'Doc::Kadoc';
license 'mit';
author 'Anton Feldmann <anton.feldmann@gmail.com>';
requires 'perl' => '5.008';
 
requires 'Template::Toolkit' => 2.24;                     # no version number
  
homepage 'https://github.com/afeldman/Josef';
bugtracker 'https://github.com/afeldman/Josef/issues';
repository 'https://github.com/afeldman/Josef.git';

all_from 'lib/Doc/Kadoc.pm';
install_script 'bin/kadoc.pl';

WriteAll;

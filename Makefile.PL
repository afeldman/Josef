use strict;
use warnings;
use 5.008;
use inc::Module::Install 1.00;

all_from 'lib/Doc/Kadoc.pm';

install_script 'bin/kadoc.pl';
 
name 'Doc::Kadoc';
license 'mit';
author 'Anton Feldmann <anton.feldmann@gmail.com>';
requires 'perl' => '5.008';
 
requires 'Template::Toolkit' => 2.24;                     # no version number
requires 'Win32' => '0.31' if $^O =~ /win32/i; # conditional requirement
 
 
homepage 'https://github.com/afeldman/Josef';
bugtracker 'https://github.com/afeldman/Josef/issues';
repository 'https://github.com/afeldman/Josef.git';

 
WriteAll;

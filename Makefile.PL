use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'HTML::ArrayGenerator',
    'VERSION_FROM'	=> 'ArrayGenerator.pm', # finds $VERSION
    'PREREQ_PM'		=> {
			    'HTML::Stream' => '0'
			   }, 
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'ArrayGenerator.pm', # retrieve abstract from module
       AUTHOR     => 'Pierre Allix <codeur(at)altern.org') : ()),
);

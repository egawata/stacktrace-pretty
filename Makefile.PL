use 5.008001;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME    => 'StackTrace::Pretty',
    VERSION_FROM => 'lib/StackTrace/Pretty.pm',
    EXE_FILES => [
        'stacktrace-pretty',
    ],
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
        (ABSTRACT_FROM  => 'lib/StackTrace/Pretty.pm',
         AUTHOR         => 'egawata') : ()),
);

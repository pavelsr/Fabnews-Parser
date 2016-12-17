#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Fabnewsru::Utils' ) || print "Bail out!\n";
}

diag( "Testing Fabnewsru::Utils $Fabnewsru::Utils::VERSION, Perl $], $^X" );

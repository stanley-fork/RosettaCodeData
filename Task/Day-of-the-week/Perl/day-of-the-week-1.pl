#!/usr/bin/perl

use strict;
use warnings;
use Time::Local;
$SIG{__WARN__} = sub { die @_ };

foreach my $i (2008 .. 2121)
{
  my $time = timelocal(0,0,12,25,11,$i);
  my ($s,$m,$h,$md,$mon,$y,$wd,$yd,$is) = localtime($time);
  if ( $wd == 0 )
  {
    print "25 Dec $i is Sunday\n";
  }
}

exit 0;

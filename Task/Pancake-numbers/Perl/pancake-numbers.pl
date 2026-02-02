#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Pancake_numbers
use warnings;

for my $n ( 1 .. 9 )
  {
  my @queue = my $last = join '', map chr 96 + $_, 1 .. $n;
  my %seen = ($last => '');
  while( @queue )
    {
    my ($stack, @flips) = split ' ', shift @queue;
    for my $flip ( 2 .. $n )
      {
      my $new = (reverse substr $stack, 0, $flip) . substr $stack, $flip;
      defined $seen{$new} or
        push @queue, $last = $seen{$new} = "$new $flip @flips";
      }
    }
  my ($stack, @flips) = split ' ', $last;
  printf "%9s  ", $stack;
  printf "size %d  score: %2d  flip the top %s\n", $n, @flips + 0, "@flips";
  }

opendir my $handle, '.' or die "Couldnt open current directory: $!";
print "$_\n" for sort readdir $handle; # output supposed to be sorted
closedir $handle;

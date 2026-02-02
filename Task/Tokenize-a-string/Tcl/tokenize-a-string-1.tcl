set string  "Hello,How,Are,You,Today"

set tokens [split $string ","]

foreach tok $tokens {
    puts -nonewline stdout "$tok\t"
}

/*REXX program separates a string of comma-delimited words, and echoes them --> terminal*/
original = 'Hello,How,Are,You,Today'             /*some words separated by commas (,).  */
Say 'The input string:' original                 /*display original string --> terminal.*/
new=original                                     /*make a copy of the string.           */
Do n=1 Until new==''                             /*keep processing until  NEW  is empty.*/
  Parse Var new word.n ',' new                   /*parse words delineated by a comma (,)*/
  End /*n*/                                      /* [?]  the new array is named   word. */
Say                                              /* NEW  is destructively parsed.       */
Say center('Words in the string',40,'-')         /*display a nice header for the list.  */
Do j=1 To n                                      /*display all the words (one per line),*/
  Say word.j||left(.,j\==n)                      /*maybe append a period (.) to a word. */
  End /*j*/                                      /*Don't append a period after the last */
Say center('End-of-list',40,'-')                 /*display a (EOL) trailer for the list.*/

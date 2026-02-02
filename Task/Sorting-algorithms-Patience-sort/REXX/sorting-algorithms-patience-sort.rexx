/*REXX program sorts a list of things (or items) using the  patience sort  algorithm.   */
Parse Arg list                                 /*obtain a list of things from the C.L  .*/
debug=0
lex=0                                          /* lex=1 to sort alphabetically          */
If list='' Then                                /* nothing specified                     */
  list='4 65 2 -31 0 99 83 782 7.88 1e1 1'     /* take this as default                  */
Say ' Input:' list
n=words(list)                                  /* number of things                      */
np=0                                           /* number of piles                       */
pi.=1                                          /* index into pile                       */
pile.=''                                       /* all piles are empty                   */
Do i=1 To n
  w=word(list,i)                               /* nex Item                              */
  If lex Then
    w='$'w
  Do j=1 To np                                 /* loop through piles                    */

    If w<word(pile.j,1) Then Do
      pile.j=w pile.j                          /* add It on top of the pile             */
      Iterate i                                /* and proceed with next item            */
      End
    Else
      Iterate                                  /* try next pile                         */
    End
  np+=1                                        /* increase the pile count.              */
  pile.np=w                                    /* first item on new pile                */
  End
If debug=1 Then Do
  Do i=1 To np
    Call debug i pi.i pile.i
    End
  End

sorted=''
Do k=1 To n                                    /* pick off the smallest from the piles. */
  v=''                                         /* this is the spiallest thingy so far···*/
  Call show 'vorher'
  Do p=1 To np                                 /* loop over piles                       */
    z=word(pile.p,pi.p)                        /* top element on pile p or empty        */
    Call debug p '-' pile.p '-' pi.p '->'  z
    If z>'' Then Do                            /* a new candidate                       */
      If v=='' Then v=z                        /* the first in this try                 */
      If z<=v  Then Do                         /* It's smaller than the previous        */
        Call debug z '<=' v
        v=z                                    /* so take this value                    */
        pu=p                                   /* and this pile is used                 */
        Call debug 'v='v 'pu='pu
        End
      End                                      /*found a low value in a pile of Items.  */
    End
  If lex Then
    vo=substr(v,2)
  sorted=sorted vo                             /* add To the output thingy (sorted) list*/
  Call debug '-->'sorted
  pi.pu+=1                                     /* bump the thingy index in pile pu      */
  Call show 'nachher'
  End
Say 'Output:' strip(sorted)                   /*stick a fork in It,  we're all Done.   */

show:
  Call debug arg(1)
  Call debug '------------------------>'sorted
  Do o=1 To np
    Call debug o pi.o pile.o
    End
  Return
debug:
  If debug Then Say arg(1)
  Return

/*REXX program determines the longest Common Substring  via a function.*/
Parse Arg a b .                 /* obtain arguments from command line  */
Select
  When a='?'Then Do             /*Not specified?  prompt for strings   */
    Say 'Enter two strings'
    Parse Pull a
    Parse Pull b
    End
  When a='' Then Do             /* else use defaults                   */
    a='thisisatest'
    b='testing123testing'
    End
  Otherwise
    Nop
  End
cs=LCsubstr(a,b)
Say '   st A ='||a pax          /*show string A and start position     */
Say '   st B ='||b pbx          /*  "     "   B  "  "      "       "   */
Say '   LCtr ='||cs             /*show the Longest Common Substring    */
Exit
/*---------------------------------------------------------------------*/
LCsubstr: Procedure Expose pax pbx /*LCsubstr: Longest Common Substring*/
  Parse Arg stra,strb,,d        /* get two strings and set d=''        */
  ll=0                          /* length of common substring so far   */
  la=length(stra)               /* length of the two strings           */
  lb=length(strb)
  switch=0
  If lb<la Then Do              /* make the shorter string stra        */
    Parse Arg strb,stra
    switch=1
    la=lb
    End
  Do pa=1 for la while pa<=la-ll
    Do k=la-pa+1 to ll By -1
      ss=substr(stra,pa,k)      /* a substring                         */
      pb=pos(ss,strb)
      If pb\==0 Then Do         /* also found in strb                  */
        If k>ll Then Do         /* longer than one found before        */
          d=ss                  /* remember the string                 */
          ll=k                  /* and its length                      */
          If switch Then        /* note the start positions            */
            Parse Value pb pa With pax pbx
          Else
            Parse Value pa pb With pax pbx
          End
        End
      End
    End
  If d='' Then Do
    d='no common substring found'
    Parse Value '' With pax pbx
    End
  return d

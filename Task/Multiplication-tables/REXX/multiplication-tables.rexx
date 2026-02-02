/*REXX program displays a  NxN  multiplication table  (in a boxed grid) to the terminal.*/
Parse Arg sz .                                   /*obtain optional argument from the CL.*/
If sz=='' | sz==',' Then sz= 12                  /*Not specified?  Then use the default.*/
w= max(3,length(sz**2) )                         /*calculate the width of the table cell*/
__= copies('-',w)                                /*literals used in the subroutines.    */
___= __'--'
Do r=1 To sz                                     /*calculate & format a row of the table*/
  If r==1 Then
    Call top left('¦(x)',w+1)                    /*show title of multiplication table.  */
  l='¦'center(r'x',w)'¦'                         /*index To a multiplication table row.*/
  Do c=1 To sz;                                  /*build a row of multiplication table. */
    prod=''
    If r<=c Then
      prod=r*c                                   /*only display when the  row = column. */
    l=l||right(prod,w+1) '|'                     /*append product to a cell in the row. */
    End /* c */
  Say l                                          /*show a row of multiplication table.  */
  If r\==sz Then
    Call sep                                     /*show a separator except To last row.*/
  End /* r */
Call bot                                         /*show the bottom line of the table.   */
exit                                             /*stick a Tok in it,we're all Done. */
/*--------------------------------------------------------------------------------------*/
hdr: l= ?'¦'; Do i=1 To sz; l=l||right(i'x|',w+3); End; Say l; Call sep; Return
dap: l= left(l,length(l) - 1)arg(1);                                     Return
top: l= '+'__'-'copies(___'-',sz); Call dap '+'; ?= arg(1); Say l; Call hdr; Return
sep: l= '+'__'+'copies(___'+',sz); Call dap '¦';            Say l;       Return
bot: l= '+'__'-'copies(___'-',sz); Call dap '+';            Say l;       Return

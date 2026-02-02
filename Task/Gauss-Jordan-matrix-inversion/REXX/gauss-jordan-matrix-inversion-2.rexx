/*REXX program performs a (square) matrix inversion  using the Gauss-Jordan method. */
data=8 3 7 5 9 12 10 11 6 2 4 13 14 15 16 17 /*the matrix element values.           */
Call build 4                                 /*assign data elements to the matrix.  */
Call show 'M','The matrix of order' n 'is:'  /*display the (square) matrix.         */
Call aux                                     /*define the auxiliary (identity) array*/
Call invert                                  /*invert the matrix, store result in X.*/
Call show 'X','The inverted matrix is:'      /*display inverted matrix.             */
Exit                                         /*stick a fork in it,  we're all done. */
/*----------------------------------------------------------------------------------*/
aux:
  x.=0
  Do i=1 To n
    x.i.i=1
    End
  Return
/*----------------------------------------------------------------------------------*/
build:                           /*set m.r.c from data      */
  Arg n
  k=0
  w=0                            /*W:  max width of a number*/
  Do r=1 To n                    /*loop over rows           */
    Do c=1 To n                  /*loop over columns        */
      k=k+1
      m.r.c=word(data,k)
      w=max(w,length(m.r.c))
      End /*c*/
    End /*r*/
  Return
/*----------------------------------------------------------------------------------*/
invert:
  Do k=1 To n
    t=m.k.k                      /*divide each matrix row by T    */
    Do c=1 To n
      m.k.c=m.k.c/t              /*process row of original matrix.*/
      x.k.c=x.k.c/t              /*   '     '   ' auxiliary   '   */
      End /*c*/
    Do r=1 To n
      If r<>k Then Do            /*skip if R is the same row as K.*/
        t=m.r.k
        Do c=1 To n
          m.r.c=m.r.c-t*m.k.c    /*process row of original matrix.*/
          x.r.c=x.r.c-t*x.k.c    /*   '     '   ' auxiliary    '  */
          End /*c*/
        End
      End /*r*/
    End /*k*/
  Return
/*-----------------------------------------------------------------------------------*/
show:
  Parse Arg which,title
  Say
  Say title
  f=4                            /*F:  fractional digits precision.*/
  Do r=1 To n
    line=''
    Do c=1 To n
      If which=='M' Then
        line=line right(m.r.c,w)
      Else
        line=line right(format(x.r.c,w,f),w+f+1)
      End /*c*/
    Say line
    End /*r*/
  Return

function fibfc(n) result(f) ! integer forward count using 128 bit integers.
    !   DOMAIN:  up to 184
    !   uses 16 byte integers
    integer(16), intent (in) :: n ! input
    integer(16)              :: f ! output
    integer(16)              :: i, fm2, fm1

    if (n>184) then
        PRINT *, "ERROR: 'a' must be in the domain 0 <= n <= 184 !"
        STOP
    end if
    f=0
    fm2=0
    fm1=1
    IF ( n > 0 ) f = 1
    IF ( n < 3 ) return
    do i = 2, n
       f=fm2+fm1
       fm2=fm1
       fm1=f
    enddo
end function

</syntaxhighlight lang="fortran">

===FORTRAN 77===
<syntaxhighlight lang="fortran">
      FUNCTION IFIB(N)
      IF (N.EQ.0) THEN
        ITEMP0=0
      ELSE IF (N.EQ.1) THEN
        ITEMP0=1
      ELSE IF (N.GT.1) THEN
        ITEMP1=0
        ITEMP0=1
        DO 1 I=2,N
          ITEMP2=ITEMP1
          ITEMP1=ITEMP0
          ITEMP0=ITEMP1+ITEMP2
    1   CONTINUE
      ELSE
        ITEMP1=1
        ITEMP0=0
        DO 2 I=-1,N,-1
          ITEMP2=ITEMP1
          ITEMP1=ITEMP0
          ITEMP0=ITEMP2-ITEMP1
    2   CONTINUE
      END IF
      IFIB=ITEMP0
      END

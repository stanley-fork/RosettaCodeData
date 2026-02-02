USING: io kernel math math.parser math.vectors random ranges sequences sets ; IN: bullsncows
: fp ( str -- ) print flush ; inline : fw ( str -- ) write flush ; inline
: bac ( -- )
  CHAR: 0 CHAR: 9 [a..b] dup 4 sample
  '[ "guess the 4-digit number: " fw readln { } like
    dup [ length 4 = ] keep [ _ in? ] all? and
    [ _ [ v= vcount ] 2keep intersect length over - over 4 =
      [ 2drop "correct!" fp f ]
      [ "bulls & cows: " fw [ >dec ] bi@ " & " glue fp t ] if
    ] [ drop "bad input" fp t ] if
  ] loop ; MAIN: bac

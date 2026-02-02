require 'misc'

plural=: conjunction define
 (":m),' ',n,'s'#~1~:m
)

bullcow=:monad define
  number=. 1+4?9
  whilst. -.guess-:number do.
    guess=. 0 "."0 prompt 'Guess my number: '
    if. (4~:#guess)+.(4~:#~.guess)+.0 e.guess e.1+i.9 do.
      if. 0=#guess do.
        echo 'Giving up.'
        return.
      end.
      echo 'Guesses must be four different non-zero digits'
      continue.
    end.
    bulls=. +/guess=number
    cows=. (+/guess e.number)-bulls
    echo bulls plural 'bull',' and ',cows plural 'cow','.'
  end.
  echo 'you win'
)

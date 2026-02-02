output← {⎕←(↑'Bulls: ' 'Cows: '),⍕⍪⍵ ⋄ ⍵}
guess ← ⍎¨{⍞←'Guess: ' ⋄ 7↓⍞}⍣((∧/⍤∊∘⎕D ∧ 4=≢)⊣)
game  ← (output ⊣ (+/⍤= , ∊+/⍤∧≠) guess)⍣(4 0≡⊣)
moo   ← 'You win!'⊣(1+4?9⍨)game⊢

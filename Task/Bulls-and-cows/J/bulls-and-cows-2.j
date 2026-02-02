output=. ['Bulls: '&,:@'Cows: 'echo@,.":@,.
guess =. $:^:(*./@e.&Num_j_*:4=#)@(1!:1@1)@echo@'Guess:'
game  =. [ $:^:(4 0-.@-:]) [:output [ (= ,&(+/) e.*.~:) 0".&>guess
moo   =. 'You win!'[ (1+4?9:) game ]

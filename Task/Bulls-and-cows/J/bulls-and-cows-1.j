output=. ['Bulls: '&,:@'Cows: 'echo@,.":@,.
guess =. 0".&>1!:1@1@echo@'Guess:'^:(*./@e.&Num_j_*:4=#)^:_.@]
game  =. ([:output [ (= ,&(+/) e.*.~:) guess)^:(4 0-.@-:])^:_.
moo   =. 'You win!'[ (1+4?9:) game ]

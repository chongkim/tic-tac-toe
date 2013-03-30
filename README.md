tic-tac-toe
===========

An unbeatable command line Tic Tac Toe program.  When it initially starts, it will take a few seconds to make a move because it is calculating all possible moves to find the best move.

Example run
===========
```
euler:tic-tac-toe ckim$ ./tic-tac-toe.rb
 | |
------
 | |
------
 | |
possible moves: [1, 2, 3, 4, 5, 6, 7, 8, 9]
input [1-9,q,s] (1 top-left, 9-lower-right, q-quit, s-skip): 1
x| |
------
 |o|
------
 | |
possible moves: [2, 3, 4, 6, 7, 8, 9]
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 9
x| |
------
 |o|
------
 |o|x
possible moves: [2, 3, 4, 6, 7]
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 2
x|x|o
------
 |o|
------
 |o|x
possible moves: [4, 6, 7]
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 7
x|x|o
------
o|o|
------
x|o|x
possible moves: [6]
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 6
x|x|o
------
o|o|x
------
x|o|x
tie
euler:tic-tac-toe ckim$
```


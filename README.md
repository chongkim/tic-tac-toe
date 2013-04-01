tic-tac-toe
===========

An unbeatable command line Tic Tac Toe program.  When it initially starts, it will take a few seconds to make a move because it is calculating all possible moves to find the best move.

Features
========
* Recognizes symmetries and filters out redundant moves.

Example run
===========
```
euler:tic-tac-toe ckim$ ./tic-tac-toe.rb
Welcome to TicTacToe

Choose who plays first
 [1] - You
 [2] - Computer

 [q[ - quit game

[1,2,q]: 1
                     1 | 2 | 3
                    -----------
                     4 | 5 | 6
                    -----------
                     7 | 8 | 9
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 1
...
                     x | 2 | 3
                    -----------
                     4 | o | 6
                    -----------
                     7 | 8 | 9
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 2

                     x | x | o
                    -----------
                     4 | o | 6
                    -----------
                     7 | 8 | 9
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 7

                     x | x | o
                    -----------
                     o | o | 6
                    -----------
                     x | 8 | 9
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 6

                     x | x | o
                    -----------
                     o | o | x
                    -----------
                     x | 8 | o
input [1-9,q] (1 top-left, 9-lower-right, q-quit): 8
                     x | x | o
                    -----------
                     o | o | x
                    -----------
                     x | x | o
tie
euler:tic-tac-toe ckim$```

TODO
====
- Ask the player if who should move first.
* Give an indication that the computer is thinking.
* Put place holders so player knows where to move.
* Ask the user at the end of the game if they want to play again.

















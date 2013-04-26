require 'spec_helper'
require 'tic-tac-toe'

def play player_choice, input_list=nil, play_again=nil
  t = TicTacToe.new
  t.stub(:gets).and_return(*[player_choice, play_again].compact)
  t.human_player.stub(:gets).and_return(*input_list) if input_list
  t.human_player.stub(:print)
  t.human_player.stub(:puts)
  t.stub(:print)
  t.stub(:puts)
  t.main_loop
end

describe TicTacToe do
  context "#to_s" do
    it "should show initial position" do
      t = TicTacToe.new
      t.board.inspect.should == "   /   /   "
      t.board.to_s.should == <<-EOF
                     0 | 1 | 2
                    -----------
                     3 | 4 | 5
                    -----------
                     6 | 7 | 8
EOF
    end
  end

  context "#initialize" do
    it "should set board" do
      t = TicTacToe.new("xx /ox / oo")
      t.board.inspect == "xx /ox / oo"
      t.board.to_s.should == <<-EOF
                     x | x | 2
                    -----------
                     o | x | 5
                    -----------
                     6 | o | o
EOF
    end
  end

  context "#main_loop" do
    it "should start a game and quit" do
      play("q")
    end
    
    it "should start a game select (1) You and quit " do
      play("1", ["q"])
    end
      
    it "should start a game select (1) You, move 1, and quit" do
      play("1", ["1", "q"])
    end
    
    it "should start a game select (2) Computer and quit" do
      play("2", ["q"])
    end

    it "should play a complete game" do
      play("1", # I go first
        ["0", "8", "7", "2", "3"], # human moves
        "n")
        # expected computer moves: [4,1,6,5]
    end
  end

  context "play a game" do
    it "should win if I let it win" do
      board = Board.new
      computer_player = ComputerPlayer.new(board)

      computer_player.move.should == 0
      board.move(1)
      computer_player.move.should == 3
      board.move(4)
      computer_player.move.should == 6
    end
  end
end

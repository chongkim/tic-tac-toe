require 'spec_helper'

def play player_choice, input_list=nil, best_moves=nil, play_again=nil
  t = TicTacToe.new
  t.stub(:gets).and_return(*[player_choice, play_again].compact)
  t.human_player.stub(:gets).and_return(*input_list) if input_list
  t.computer_player.stub(:best_move).and_return(*best_moves) if best_moves
  t.computer_player.stub(:print)
  t.computer_player.stub(:puts)
  t.human_player.stub(:print)
  t.human_player.stub(:puts)
  t.stub(:print)
  t.stub(:puts)
  t.main_loop
end

describe TicTacToe do
  context "#to_s" do
    it "should show initial position" do
      TicTacToe.new.to_s.should == <<-EOF
                     1 | 2 | 3
                    -----------
                     4 | 5 | 6
                    -----------
                     7 | 8 | 9
EOF
    end
  end

  context "#initialize" do
    it "should set board" do
      TicTacToe.new("xx ", "ox ", " oo").to_s.should == <<-EOF
                     x | x | 3
                    -----------
                     o | x | 6
                    -----------
                     7 | o | o
EOF
    end
  end

  context "play a game" do
    it "should start a game and quit" do
      play("q")
    end
    
    it "should start a game select (1) You and quit " do
      play("1", ["q"])
    end
      
    it "should start a game select (1) You, move 1, and quit" do
      play("1", ["1", "q"], [2])
    end
    
    it "should start a game select (2) Computer and quit" do
      play("2", ["q"], [1])
    end

    it "should play a complete game" do
      play("1", # I go first
        ["1", "9", "8", "3", "4"], # human moves
        [ 5,   2,   7,   6],
        "n") # computer moves
    end
  end
end

require 'spec_helper'

def play input_list, best_moves=nil
  t = TicTacToe.new
  t.stub(:gets).and_return(*input_list)
  t.stub(:best_move).and_return(*best_moves) if best_moves
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

  context "#prompt_for_move" do
    it "should prompt for input" do
      t = TicTacToe.new
      t.stub(:puts)
      t.stub(:print)
      t.stub(:gets).and_return("2")
      t.prompt_for_move.should == "2"
    end
  end

  context "play a game" do
    it "should start a game and quit" do
      play(["q"])
    end
    
    it "should start a game select (1) You and quit " do
      play(["1", "q"])
    end
      
    it "should start a game select (1) You, move 1, and quit" do
      play(["1", "1", "q"], [2])
    end
    
    it "should start a game select (2) Computer and quit" do
      play(["2", "q"], [1])
    end

    it "should play a complete game" do
      play(["1", # I go first
        "1", # computer moves 5
        "9", # computer moves 2
        "8", # computer moves 7
        "3", # computer moves 6
        "4", "n"], [5,2,7,6])
    end
  end
end

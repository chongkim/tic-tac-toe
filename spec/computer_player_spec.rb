require 'computer_player'
require 'symmetry'

$debug = false

describe ComputerPlayer do
  context "#deep_evaluate" do
    it "should do a deep evaluate" do
      ComputerPlayer.new(Board.new("XO /OX /XO ")).deep_evaluate.should > 0
      ComputerPlayer.new(Board.new("XXX /OOO /    /    ")).deep_evaluate.should > 0
    end
  end

  context "#best_moves" do
    it "should come up with best moves for simple win" do
      ComputerPlayer.new(Board.new("XX /OO /   ")).best_moves.should == [2,5,6,7,8]
      ComputerPlayer.new(Board.new("XO /OX /   ")).best_moves.should == [8,2,5]
    end

    it "should come up with best moves with deep evaluation" do
      ComputerPlayer.new(Board.new("XO /O  /X  ")).best_moves.should == [4,8,5,7,2]
    end
  end
end

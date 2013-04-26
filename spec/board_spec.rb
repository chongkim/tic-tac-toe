require 'spec_helper'

describe Board do
  context "#move" do
    it "should handle a move" do
      board = Board.new("   /   /   ")
      board.move(0)
      board.inspect.should == "X  /   /   "
    end
  end

  context "#possible_moves" do
    it "should come up with moves for initial position" do
      Board.new("   /   /   ").possible_moves.should == [0,1,2,3,4,5,6,7,8]
    end
    it "should come up with moves as second player" do
      Board.new("   / X /   ").possible_moves.should == [0,1,2,3,5,6,7,8]
    end
  end

  context "#evaluate" do
    it "should evaluate a win" do
      Board.new("XXX/ O /  O").evaluate.should > 0
      Board.new(" O /XXX/ O ").evaluate.should > 0
      Board.new(" OO/   /XXX").evaluate.should > 0

      Board.new("XXO/XO /X O").evaluate.should > 0
      Board.new(" X /XXO/OX ").evaluate.should > 0
      Board.new(" OX/  X/OOX").evaluate.should > 0

      Board.new("XXO/ XO/ OX").evaluate.should > 0
      Board.new(" OX/ XO/XOO").evaluate.should > 0
    end
    it "should evaluate a loss" do
      Board.new("OOO/ X /  X").evaluate.should < 0
      Board.new(" X /OOO/ X ").evaluate.should < 0
      Board.new(" XX/   /OOO").evaluate.should < 0

      Board.new("OOX/OX /O X").evaluate.should < 0
      Board.new(" O /OOX/XO ").evaluate.should < 0
      Board.new(" XO/  O/XXO").evaluate.should < 0

      Board.new("OOX/ OX/ XO").evaluate.should < 0
      Board.new(" XO/ OX/OXX").evaluate.should < 0
    end
    it "should evaluate undetermined" do
      Board.new("   /   /   ").evaluate.should == 0
      Board.new("X O/ X /O  ").evaluate.should == 0
    end
  end
end


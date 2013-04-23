require 'spec_helper'
require 'board'

describe Board do
  context "#move" do
    it "should handle a move" do
      board = Board.new("   /   /   ")
      board.move(1)
      board.inspect.should == "x  /   /   "
    end
  end

  context "#possible_moves" do
    it "should come up with moves for initial position" do
      Board.new("   /   /   ").possible_moves.should == [1,2,3,4,5,6,7,8,9]
    end
    it "should come up with moves as second player" do
      Board.new("   / x /   ").possible_moves.should == [1,2,3,4,6,7,8,9]
    end
  end

  context "#evaluate" do
    it "should evaluate a win" do
      Board.new("xxx/ o /  o").evaluate.should > 0
      Board.new(" o /xxx/ o ").evaluate.should > 0
      Board.new(" oo/   /xxx").evaluate.should > 0

      Board.new("xxo/xo /x o").evaluate.should > 0
      Board.new(" x /xxo/ox ").evaluate.should > 0
      Board.new(" ox/  x/oox").evaluate.should > 0

      Board.new("xxo/ xo/ ox").evaluate.should > 0
      Board.new(" ox/ xo/xoo").evaluate.should > 0
    end
    it "should evaluate a loss" do
      Board.new("ooo/ x /  x").evaluate.should < 0
      Board.new(" x /ooo/ x ").evaluate.should < 0
      Board.new(" xx/   /ooo").evaluate.should < 0

      Board.new("oox/ox /o x").evaluate.should < 0
      Board.new(" o /oox/xo ").evaluate.should < 0
      Board.new(" xo/  o/xxo").evaluate.should < 0

      Board.new("oox/ ox/ xo").evaluate.should < 0
      Board.new(" xo/ ox/oxx").evaluate.should < 0
    end
    it "should evaluate undetermined" do
      Board.new("   /   /   ").evaluate.should == 0
      Board.new("x o/ x /o  ").evaluate.should == 0
    end
  end

end


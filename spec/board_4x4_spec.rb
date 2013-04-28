require 'spec_helper'

describe Board, "4x4" do
  context "#initialize" do
    it "should handle size arg" do
      Board.new(4).inspect.should == "    /    /    /    "
    end
    it "should handle initial 4x4 position" do
      Board.new(" x  /    /    /    ").inspect.should == " X  /    /    /    "
    end
  end

  context "#to_s" do
    it "should show initial position" do
      Board.new(4).to_s.should == <<-EOF
                      0 |  1 |  2 |  3 
                    -------------------
                      4 |  5 |  6 |  7 
                    -------------------
                      8 |  9 | 10 | 11 
                    -------------------
                     12 | 13 | 14 | 15 
EOF
    end
    
    it "should show set board" do
      Board.new(" XX /O X / O O/ x o").to_s.should == <<-EOF
                      0 |  X |  X |  3 
                    -------------------
                      O |  5 |  X |  7 
                    -------------------
                      8 |  O | 10 |  O 
                    -------------------
                     12 |  X | 14 |  O 
EOF
    end
  end

  context "#move" do
    it "should handle a move" do
      board = Board.new("    /    /    /    ")
      board.move(0)
      board.inspect.should == "X   /    /    /    "
    end
  end

  context "#possible_moves" do
    it "should come up with moves for initial position" do
      Board.new("    /    /    /    ").possible_moves.should == (0..15).to_a
    end
    it "should come up with moves as second player" do
      Board.new("    / X  /    /    ").possible_moves.should == (0..15).to_a-[5]
    end
  end

  context "#evaluate" do
    it "should evaluate a win" do
      Board.new("xxxx/ o  / oo /    ").evaluate.should > 0
      Board.new(" o  /xxxx/ oo / o  ").evaluate.should > 0
      Board.new(" oo /    /xxxx/  o ").evaluate.should > 0
      Board.new(" oo /  o /    /xxxx").evaluate.should > 0

      Board.new("xxo /xo  /x o /x  o").evaluate.should > 0
      Board.new(" x  /xxo /ox  /ox  ").evaluate.should > 0
      Board.new(" ox /  x /oox /o x ").evaluate.should > 0
      Board.new("  ox/   x/oo x/o  x").evaluate.should > 0

      Board.new("xxo / xo / ox /o  x").evaluate.should > 0
      Board.new("  ox/  xo/ xoo/xo  ").evaluate.should > 0
    end
    it "should evaluate a loss" do
      Board.new("oooo/ x  /   x/   x").evaluate.should < 0
    end
    it "should evaluate undetermined" do
      Board.new("    /    /    /    ").evaluate.should == 0
      Board.new("x o / x  /ox  /    ").evaluate.should == 0
    end
  end
end


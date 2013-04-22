require 'spec_helper'

describe Board do
  context "#possible_moves" do
    it "should come up with moves for initial position" do
      Board.new("   ", "   ", "   ").possible_moves.should == [1,2,3,4,5,6,7,8,9]
    end
    it "should come up with moves as second player" do
      Board.new("   ", " x ", "   ").possible_moves.should == [1,2,3,4,6,7,8,9]
      Board.new("x  ", "   ", "   ").possible_moves.should == [2,3,4,5,6,7,8,9]
    end
  end

  context "#evaluate" do
    it "should evaluate a win across row 1" do
      Board.new("xxx", " o ", "  o").evaluate.should > 0
      Board.new(" o ", "xxx", " o ").evaluate.should > 0
      Board.new(" oo", "   ", "xxx").evaluate.should > 0

      Board.new("xxo", "xo ", "x o").evaluate.should > 0
      Board.new(" x ", "xxo", "ox ").evaluate.should > 0
      Board.new(" ox", "  x", "oox").evaluate.should > 0

      Board.new("xxo", " xo", " ox").evaluate.should > 0
      Board.new(" ox", " xo", "xoo").evaluate.should > 0
    end

    it "should evaluate a loss" do
      Board.new("ooo", " x ", "  x").evaluate.should < 0
      Board.new(" x ", "ooo", " x ").evaluate.should < 0
      Board.new(" xx", "   ", "ooo").evaluate.should < 0

      Board.new("oox", "ox ", "o x").evaluate.should < 0
      Board.new(" o ", "oox", "xo ").evaluate.should < 0
      Board.new(" xo", "  o", "xxo").evaluate.should < 0

      Board.new("oox", " ox", " xo").evaluate.should < 0
      Board.new(" xo", " ox", "oxx").evaluate.should < 0
    end

    it "should evaluate undetermined" do
      Board.new("   ", "   ", "   ").evaluate.should == 0
      Board.new("x o", " x ", "o  ").evaluate.should == 0
    end
  end

  context "#move" do
    it "should handle a move" do
      t = Board.new("   ", "   ", "   ")
      t.move(1)
      (1..9).map{|pos| t[pos] }.should == "x        ".chars.map(&:to_sym)
    end
  end

  context "#deep_evaluate" do
    it "should do a deep evaluate" do
      Board.new("xo ", "ox ", "xo ").deep_evaluate.should > 0
    end
  end

  context "#symmetries" do
    # a square has symmetry of order 8
    it "should find all symmetries" do
      Board.new.symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
      Board.new("   ", " x ", "   ").symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
    end
    
    it "should find rotation 0 degrees (this is identity)" do
      Board.new("xxo", "xo ", " o ").symmetries.should == [:r1]
    end
    
    it "should find rotation 90 degrees" do
      Board.new("   ", " x ", "   ").symmetries.should include :r2
    end
    
    it "should find rotation 180 degrees" do
      Board.new("x  ", "o o", "  x").symmetries.should include :r3
    end
    
    it "should find rotation 270 degrees" do
      Board.new("   ", " x ", "   ").symmetries.should include :r4
    end
    
    it "should find horizontal flip" do
      Board.new("xo ", "   ","xo ").symmetries.should include :h
    end
    
    it "should find vertical flip" do
      Board.new("x x", "o o","   ").symmetries.should == [:r1, :v]
    end
    
    it "should find major diagonal flip" do
      Board.new("x  ", " o ", "  x").symmetries.should include :d1
    end
    
    it "should find major diagonal flip" do
      Board.new("  x", " o ", "x  ").symmetries.should include :d2
    end
  end

  context "#symmetry_equivalent_classes" do
    it "should find symmetry equivalent classes" do
      t = Board.new.symmetry_equivalent_classes.map(&:sort).should == [[1,3,7,9],[2,4,6,8],[5]]
    end
  end

  context "#possible_moves_minus_symmetry" do
    it "should come up with a list of possible moves minus symmetry" do
      Board.new("   ", "   ", "   ").possible_moves_minus_symmetry.should == [1,2,5]
      Board.new("xo ", " x ", "  o").possible_moves_minus_symmetry.should == [3,4,6,7,8]
      Board.new("xxo", " ox", "oxo").possible_moves_minus_symmetry.should == [4]
      Board.new("   ", " x ", "   ").possible_moves_minus_symmetry.should == [1,2]
      Board.new("x  ", "   ", "   ").possible_moves_minus_symmetry.should == [2,3,5,6,9]
    end
  end
    
  context "#best_moves" do
    it "should come up with best moves for simple win" do
      Board.new("xx ", "oo ", "   ").best_moves.should == [3,6,7,8,9]
      Board.new("xo ", "ox ", "   ").best_moves.should == [9,3,6]
    end

    it "should come up with best moves with deep evaluation" do
      Board.new("xo ", "o  ", "x  ").best_moves.should == [5,9,6,8,3]
    end
  end
end


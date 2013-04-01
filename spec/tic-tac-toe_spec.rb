require 'spec_helper'

describe TicTacToe do
  it "should show initial position" do
    TicTacToe.new.to_s.should == <<-EOF
                     \e[30;1m1\e[0m | \e[30;1m2\e[0m | \e[30;1m3\e[0m
                    -----------
                     \e[30;1m4\e[0m | \e[30;1m5\e[0m | \e[30;1m6\e[0m
                    -----------
                     \e[30;1m7\e[0m | \e[30;1m8\e[0m | \e[30;1m9\e[0m
EOF
  end
  
  it "should prompt for input" do
    t = TicTacToe.new
    t.stub(:gets).and_return("2")
    t.stub(:print)
    t.stub(:puts)
    t.prompt.should == "2"
  end

  it "should set board" do
    TicTacToe.new("xx ", "ox ", " oo").to_s.should == <<-EOF
                     x | x | \e[30;1m3\e[0m
                    -----------
                     o | x | \e[30;1m6\e[0m
                    -----------
                     \e[30;1m7\e[0m | o | o
EOF
  end

  it "should come up with a list of possible moves" do
    TicTacToe.new("   ", "   ", "   ").possible_moves_minus_symmetry.should == [1,2,5]
    TicTacToe.new("xo ", " x ", "  o").possible_moves_minus_symmetry.should == [3,4,6,7,8]
    TicTacToe.new("xxo", " ox", "oxo").possible_moves_minus_symmetry.should == [4]
  end

  it "should evaluate a win" do
    TicTacToe.new("xxx", " o ", "  o").evaluate.should > 0
    TicTacToe.new(" o ", "xxx", " o ").evaluate.should > 0
    TicTacToe.new(" oo", "   ", "xxx").evaluate.should > 0

    TicTacToe.new("xxo", "xo ", "x o").evaluate.should > 0
    TicTacToe.new(" x ", "xxo", "ox ").evaluate.should > 0
    TicTacToe.new(" ox", "  x", "oox").evaluate.should > 0

    TicTacToe.new("xxo", " xo", " ox").evaluate.should > 0
    TicTacToe.new(" ox", " xo", "xoo").evaluate.should > 0
  end

  it "should evaluate a loss" do
    TicTacToe.new("ooo", " x ", "  x").evaluate.should < 0
    TicTacToe.new(" x ", "ooo", " x ").evaluate.should < 0
    TicTacToe.new(" xx", "   ", "ooo").evaluate.should < 0

    TicTacToe.new("oox", "ox ", "o x").evaluate.should < 0
    TicTacToe.new(" o ", "oox", "xo ").evaluate.should < 0
    TicTacToe.new(" xo", "  o", "xxo").evaluate.should < 0

    TicTacToe.new("oox", " ox", " xo").evaluate.should < 0
    TicTacToe.new(" xo", " ox", "oxx").evaluate.should < 0
  end

  it "should evaluate undetermined" do
    TicTacToe.new("   ", "   ", "   ").evaluate.should == 0
    TicTacToe.new("x o", " x ", "o  ").evaluate.should == 0
  end

  it "should handle a move" do
    t = TicTacToe.new("   ", "   ", "   ").move(1).positions.should == "x        ".scan(/./)
  end

  it "should do a deep evaluate" do
    TicTacToe.new("xo ", "ox ", "xo ").deep_evaluate.should > 0
  end

  it "should come up with best moves" do
    TicTacToe.new("xx ", "oo ", "   ").best_moves.should == [3,6,7,8,9]
    TicTacToe.new("xo ", "ox ", "   ").best_moves.should == [9,3,6]
  end

  it "should come up with best moves with deep evaluation" do
    TicTacToe.new("xo ", "o  ", "x  ").best_moves.should == [5,9,6,8,3]
  end

  describe "symmetry" do
    it "should convert positions to coords" do
      t = TicTacToe.new
      t.to_xy(1).should == [-1,1]
      t.to_xy(2).should == [ 0,1]
      t.to_xy(3).should == [ 1,1]
      t.to_xy(4).should == [-1,0]
      t.to_xy(5).should == [ 0,0]
      t.to_xy(6).should == [ 1,0]
      t.to_xy(7).should == [-1,-1]
      t.to_xy(8).should == [ 0,-1]
      t.to_xy(9).should == [ 1,-1]
    end

    it "should convert coords to positions" do
      t = TicTacToe.new
      t.from_xy(-1,1).should == 1
      t.from_xy( 0,1).should == 2
      t.from_xy( 1,1).should == 3
      t.from_xy(-1,0).should == 4
      t.from_xy( 0,0).should == 5
      t.from_xy( 1,0).should == 6
      t.from_xy(-1,-1).should == 7
      t.from_xy( 0,-1).should == 8
      t.from_xy( 1,-1).should == 9
    end
    # a square has symmetry of order 8
    it "should find all symmetries" do
      TicTacToe.new.symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
      TicTacToe.new("   ", " x ", "   ").symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
    end
    it "should find rotation 0 degrees (this is identity" do
      TicTacToe.new("xxo", "xo ", " o ").symmetries.should == [:r1]
    end
    it "should find rotation 90 degrees" do
      TicTacToe.new("   ", " x ", "   ").symmetries.should include :r2
    end
    it "should find rotation 180 degrees" do
      TicTacToe.new("x  ", "o o", "  x").symmetries.should include :r3
    end
    it "should find rotation 270 degrees" do
      TicTacToe.new("   ", " x ", "   ").symmetries.should include :r4
    end
    it "should find horizontal flip" do
      TicTacToe.new("xo ", "   ","xo ").symmetries.should include :h
    end
    it "should find vertical flip" do
      TicTacToe.new("x x", "o o","   ").symmetries.should == [:r1, :v]
    end
    it "should find major diagonal flip" do
      TicTacToe.new("x  ", " o ", "  x").symmetries.should include :d1
    end
    it "should find major diagonal flip" do
      TicTacToe.new("  x", " o ", "x  ").symmetries.should include :d2
    end
  end
end

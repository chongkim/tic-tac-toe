require 'spec_helper'

describe TicTacToe do
  it "should show initial position" do
    TicTacToe.new.to_s.should == <<-EOF
 | | 
------
 | | 
------
 | | 
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
x|x| 
------
o|x| 
------
 |o|o
    EOF
  end

  it "should come up with a list of possible moves" do
    TicTacToe.new("   ", "   ", "   ").possible_moves.should == [1,2,3,4,5,6,7,8,9]
    TicTacToe.new("xo ", " x ", "  o").possible_moves.should == [3,4,6,7,8]
    TicTacToe.new("xxo", " ox", "oxo").possible_moves.should == [4]
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
    t = TicTacToe.new("   ", "   ", "   ").move(1).positions(1,2,3,4,5,6,7,8,9).should == "x        "
  end

  it "should do a deep evaluate" do
    TicTacToe.new("xo ", "ox ", "xo ").deep_evaluate.should > 0
  end

  it "should come up with best moves" do
    TicTacToe.new("xx ", "oo ", "   ").best_moves.should == [3,6,7,8,9]
    TicTacToe.new("xo ", "ox ", "   ").best_moves.should == [9,3,7,6,8]
  end

  it "should come up with best moves with deep evaluation" do
    TicTacToe.new("xo ", "o  ", "x  ").best_moves.should == [5,9,6,8,3]
  end
  
end

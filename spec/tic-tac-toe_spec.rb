require 'spec_helper'

describe Board do
  it "should come up with a list of possible moves" do
    Board.new("   ", "   ", "   ").possible_moves.should == [1,2,3,4,5,6,7,8,9]
    Board.new("   ", " x ", "   ").possible_moves.should == [1,2,3,4,6,7,8,9]
    Board.new("x  ", "   ", "   ").possible_moves.should == [2,3,4,5,6,7,8,9]
  end
  
  it "should evaluate a win" do
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

  it "should handle a move" do
    t = Board.new("   ", "   ", "   ")
    t.move(1)
    (1..9).map{|pos| t[pos] }.should == "x        ".scan(/./)
  end

  it "should do a deep evaluate" do
    Board.new("xo ", "ox ", "xo ").deep_evaluate.should > 0
  end

  describe "symmetry" do
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

    it "should find symmetry equivalent classes" do
      t = Board.new.symmetry_equivalent_classes.map(&:sort).should == [[1,3,7,9],[2,4,6,8],[5]]
    end
    
    it "should come up with a list of possible moves minus symmetry" do
      Board.new("   ", "   ", "   ").possible_moves_minus_symmetry.should == [1,2,5]
      Board.new("xo ", " x ", "  o").possible_moves_minus_symmetry.should == [3,4,6,7,8]
      Board.new("xxo", " ox", "oxo").possible_moves_minus_symmetry.should == [4]
      Board.new("   ", " x ", "   ").possible_moves_minus_symmetry.should == [1,2]
      Board.new("x  ", "   ", "   ").possible_moves_minus_symmetry.should == [2,3,5,6,9]
    end
    
    it "should come up with best moves" do
      Board.new("xx ", "oo ", "   ").best_moves.should == [3,6,7,8,9]
      Board.new("xo ", "ox ", "   ").best_moves.should == [9,3,6]
    end

    it "should come up with best moves with deep evaluation" do
      Board.new("xo ", "o  ", "x  ").best_moves.should == [5,9,6,8,3]
    end
  end
end

def play input_list, best_moves=nil
  t = TicTacToe.new
  t.stub(:gets).and_return(*input_list)
  t.stub(:best_move).and_return(*best_moves) if best_moves
  t.stub(:print)
  t.stub(:puts)
  t.main_loop
end

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
    t.stub(:puts)
    t.stub(:print)
    t.stub(:gets).and_return("2")
    t.prompt_for_move.should == "2"
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

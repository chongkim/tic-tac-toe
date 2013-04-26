require 'computer_player'

describe ComputerPlayer do
  context "#deep_evaluate" do
    it "should do a deep evaluate" do
      ComputerPlayer.new(Board.new("XO /OX /XO ")).deep_evaluate.should > 0
    end
  end

  context "#symmetries" do
    # a square has symmetry of order 8
    it "should find all symmetries" do
      ComputerPlayer.new(Board.new).symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
      ComputerPlayer.new(Board.new("   / X /   ")).symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
    end
    
    it "should find rotation 0 degrees (this is identity)" do
      ComputerPlayer.new(Board.new("XXO/XO / O ")).symmetries.should == [:r1]
    end
    
    it "should find rotation 90 degrees" do
      ComputerPlayer.new(Board.new("   / X /   ")).symmetries.should include :r2
    end
    
    it "should find rotation 180 degrees" do
      ComputerPlayer.new(Board.new("X  /O O/  X")).symmetries.should include :r3
    end
    
    it "should find rotation 270 degrees" do
      ComputerPlayer.new(Board.new("   / X /   ")).symmetries.should include :r4
    end
    
    it "should find horizontal flip" do
      ComputerPlayer.new(Board.new("XO /   /XO ")).symmetries.should include :h
    end
    
    it "should find vertical flip" do
      ComputerPlayer.new(Board.new("X X/O O/   ")).symmetries.should == [:r1, :v]
    end
    
    it "should find major diagonal flip" do
      ComputerPlayer.new(Board.new("X  / O /  X")).symmetries.should include :d1
    end
    
    it "should find major diagonal flip" do
      ComputerPlayer.new(Board.new("  X/ O /X  ")).symmetries.should include :d2
    end
  end

  context "#symmetry_equivalent_classes" do
    it "should find symmetry equivalent classes" do
      ComputerPlayer.new(Board.new).symmetry_equivalent_classes.map(&:sort).should == [[0,2,6,8],[1,3,5,7],[4]]
    end
  end

  context "#possible_moves_minus_symmetry" do
    it "should come up with a list of possible moves minus symmetry" do
      ComputerPlayer.new(Board.new("   /   /   ")).possible_moves_minus_symmetry.should == [0,1,4]
      ComputerPlayer.new(Board.new("XO / X /  O")).possible_moves_minus_symmetry.should == [2,3,5,6,7]
      ComputerPlayer.new(Board.new("XXO/ OX/OXO")).possible_moves_minus_symmetry.should == [3]
      ComputerPlayer.new(Board.new("   / X /   ")).possible_moves_minus_symmetry.should == [0,1]
      ComputerPlayer.new(Board.new("X  /   /   ")).possible_moves_minus_symmetry.should == [1,2,4,5,8]
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

require 'computer_player'

describe ComputerPlayer do
  context "#deep_evaluate" do
    it "should do a deep evaluate" do
      ComputerPlayer.new(Board.new("xo /ox /xo ")).deep_evaluate.should > 0
    end
  end

  context "#symmetries" do
    # a square has symmetry of order 8
    it "should find all symmetries" do
      ComputerPlayer.new(Board.new).symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
      ComputerPlayer.new(Board.new("   / x /   ")).symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
    end
    
    it "should find rotation 0 degrees (this is identity)" do
      ComputerPlayer.new(Board.new("xxo/xo / o ")).symmetries.should == [:r1]
    end
    
    it "should find rotation 90 degrees" do
      ComputerPlayer.new(Board.new("   / x /   ")).symmetries.should include :r2
    end
    
    it "should find rotation 180 degrees" do
      ComputerPlayer.new(Board.new("x  /o o/  x")).symmetries.should include :r3
    end
    
    it "should find rotation 270 degrees" do
      ComputerPlayer.new(Board.new("   / x /   ")).symmetries.should include :r4
    end
    
    it "should find horizontal flip" do
      ComputerPlayer.new(Board.new("xo /   /xo ")).symmetries.should include :h
    end
    
    it "should find vertical flip" do
      ComputerPlayer.new(Board.new("x x/o o/   ")).symmetries.should == [:r1, :v]
    end
    
    it "should find major diagonal flip" do
      ComputerPlayer.new(Board.new("x  / o /  x")).symmetries.should include :d1
    end
    
    it "should find major diagonal flip" do
      ComputerPlayer.new(Board.new("  x/ o /x  ")).symmetries.should include :d2
    end
  end

  context "#symmetry_equivalent_classes" do
    it "should find symmetry equivalent classes" do
      ComputerPlayer.new(Board.new).symmetry_equivalent_classes.map(&:sort).should == [[1,3,7,9],[2,4,6,8],[5]]
    end
  end

  context "#possible_moves_minus_symmetry" do
    it "should come up with a list of possible moves minus symmetry" do
      ComputerPlayer.new(Board.new("   /   /   ")).possible_moves_minus_symmetry.should == [1,2,5]
      ComputerPlayer.new(Board.new("xo / x /  o")).possible_moves_minus_symmetry.should == [3,4,6,7,8]
      ComputerPlayer.new(Board.new("xxo/ ox/oxo")).possible_moves_minus_symmetry.should == [4]
      ComputerPlayer.new(Board.new("   / x /   ")).possible_moves_minus_symmetry.should == [1,2]
      ComputerPlayer.new(Board.new("x  /   /   ")).possible_moves_minus_symmetry.should == [2,3,5,6,9]
    end
  end
    
  context "#best_moves" do
    it "should come up with best moves for simple win" do
      ComputerPlayer.new(Board.new("xx /oo /   ")).best_moves.should == [3,6,7,8,9]
      ComputerPlayer.new(Board.new("xo /ox /   ")).best_moves.should == [9,3,6]
    end

    it "should come up with best moves with deep evaluation" do
      ComputerPlayer.new(Board.new("xo /o  /x  ")).best_moves.should == [5,9,6,8,3]
    end
  end
end
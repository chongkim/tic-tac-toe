describe Symmetry do
  context "#symmetries" do
    # a square has symmetry of order 8
    it "should find all symmetries" do
      Symmetry.new(Board.new).symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
      Symmetry.new(Board.new("   / X /   ")).symmetries.should == [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2]
    end
    
    it "should find rotation 0 degrees (this is identity)" do
      Symmetry.new(Board.new("XXO/XO / O ")).symmetries.should == [:r1]
    end
    
    it "should find rotation 90 degrees" do
      Symmetry.new(Board.new("   / X /   ")).symmetries.should include :r2
    end
    
    it "should find rotation 180 degrees" do
      Symmetry.new(Board.new("X  /O O/  X")).symmetries.should include :r3
    end
    
    it "should find rotation 270 degrees" do
      Symmetry.new(Board.new("   / X /   ")).symmetries.should include :r4
    end
    
    it "should find horizontal flip" do
      Symmetry.new(Board.new("XO /   /XO ")).symmetries.should include :h
    end
    
    it "should find vertical flip" do
      Symmetry.new(Board.new("X X/O O/   ")).symmetries.should == [:r1, :v]
    end
    
    it "should find major diagonal flip" do
      Symmetry.new(Board.new("X  / O /  X")).symmetries.should include :d1
    end
    
    it "should find major diagonal flip" do
      Symmetry.new(Board.new("  X/ O /X  ")).symmetries.should include :d2
    end
  end

  context "#symmetry_equivalent_classes" do
    it "should find symmetry equivalent classes" do
      Symmetry.new(Board.new).symmetry_equivalent_classes.map(&:sort).should == [[0,2,6,8],[1,3,5,7],[4]]
    end
  end

  context "#possible_moves_minus_symmetry" do
    it "should come up with a list of possible moves minus symmetry" do
      Symmetry.new(Board.new("   /   /   ")).possible_moves_minus_symmetry.should == [0,1,4]
      Symmetry.new(Board.new("XO / X /  O")).possible_moves_minus_symmetry.should == [2,3,5,6,7]
      Symmetry.new(Board.new("XXO/ OX/OXO")).possible_moves_minus_symmetry.should == [3]
      Symmetry.new(Board.new("   / X /   ")).possible_moves_minus_symmetry.should == [0,1]
      Symmetry.new(Board.new("X  /   /   ")).possible_moves_minus_symmetry.should == [1,2,4,5,8]
    end
  end

  context "#transform_key" do
    it "should rotate a key" do
      symmetry = Symmetry.new(Board.new("XX / O /   "))
      symmetry.transform_key(:r1).should == "XX / O /   "
      symmetry.transform_key(:r2).should == "   /XO /X  "
      symmetry.transform_key(:r3).should == "   / O / XX"
      symmetry.transform_key(:r4).should == "  X/ OX/   "
    end
    it "should flip a key" do
      symmetry = Symmetry.new(Board.new("XX / O /   "))
      symmetry.transform_key(:h).should  == "   / O /XX "
      symmetry.transform_key(:v).should  == " XX/ O /   "
      symmetry.transform_key(:d1).should == "   / OX/  X"
      symmetry.transform_key(:d2).should == "X  /XO /   "
    end
  end

  context "#lookup_symmetrical_evaluation" do
    it "store an evaluation and retrieve it" do
      # store the evaluation of the rotated board
      # then try to retrieve it with lookup_symmetrical_evaluation
      board = Board.new(" x /   /   ")
      symmetry = Symmetry.new(board)
      key = symmetry.transform_key(:r2)
      symmetry.evaluations[key] = 123
      symmetry.evaluations[key].should == 123
      symmetry.lookup_symmetrical_evaluation.should == 123
    end
  end
end
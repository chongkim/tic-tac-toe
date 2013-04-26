require 'spec_helper'

describe Piece do
  context "#initialize" do
    it "should create X" do
      Piece.new("X").symbol.should == :X
      Piece.new("x").symbol.should == :X
      Piece.new(:X).symbol.should == :X
      Piece.new(:x).symbol.should == :X
    end
    it "should create O" do
      Piece.new("O").symbol.should == :O
      Piece.new("o").symbol.should == :O
      Piece.new(:O).symbol.should == :O
      Piece.new(:o).symbol.should == :O
    end
    it "should create ' '" do
      Piece.new(" ").symbol.should == :' '
      Piece.new(:' ').symbol.should == :' '
    end
    it "should throw an exception for anything else" do
      expect{ Piece.new("-") }.to raise_error
    end
  end
  context "#==" do
    it "should compare with a symbol" do
      (Piece.new("x") == :x).should be_true
    end
    it "should compare with a string" do
      (Piece.new("x") == "x").should be_true
    end
  end
end

require 'spec_helper'
require 'human_player'

describe HumanPlayer do
  context "#prompt_for_move" do
    it "should prompt for input" do
      human_player = HumanPlayer.new(Board.new)
      human_player.stub(:puts)
      human_player.stub(:print)
      human_player.stub(:gets).and_return("2")
      
      human_player.prompt_for_move.should == "2"
    end
  end
  context "#move" do
    it "should make a move on an empty board" do
      human_player = HumanPlayer.new(Board.new)
      human_player.stub(:prompt_for_move).and_return("1")

      human_player.move

      human_player.board.inspect.should == " X /   /   "
    end
  end
end

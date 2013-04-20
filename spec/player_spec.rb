require 'spec_helper'
require 'player'

describe HumanPlayer do
  context "#prompt_for_move" do
    it "should prompt for input" do
      board = Board.new
      human_player = HumanPlayer.new(board)
      human_player.stub(:puts)
      human_player.stub(:print)
      human_player.stub(:gets).and_return("2")
      human_player.prompt_for_move.should == "2"
    end
  end
end

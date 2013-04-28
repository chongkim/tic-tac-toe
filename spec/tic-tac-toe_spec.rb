def play board_choice, player_choice, input_list=nil, play_again=nil
  t = TicTacToe.new(Board.new)
  t.stub(:gets).and_return(*[board_choice, player_choice, play_again].compact)
  t.human_player.stub(:gets).and_return(*input_list) if input_list
  t.human_player.stub(:print)
  t.human_player.stub(:puts)
  t.stub(:print)
  t.stub(:puts)
  t.main_loop
end

describe TicTacToe do

  context "#main_loop" do
    it "should start a game and quit" do
      play("q", "q")
    end
    
    it "should select (1) 3x3 (1) You and quit " do
      play("1", "1", ["q"])
    end
      
    it "should select (1) 3x3 (1) You, move 1, and quit" do
      play("1", "1", ["1", "q"])
    end
    
    it "should select (1) 3x3 (2) Computer and quit" do
      play("1", "2", ["q"])
    end

    it "should select (1) 3x3 (1) You, and play a complete game" do
      play("1", "1",
        ["0", "8", "7", "2", "3"], # human moves
        "n")
        # expected computer moves: [4,1,6,5]
    end

    it "should select (1) 3x3 (2) Computer and win" do
      play("1", "2",
        ["1", "q"], # human moves
        "n")
        # expected computer moves: [4,1,6,5]
    end
  end

  context "play a game" do
    it "should win if I let it win" do
      board = Board.new
      computer_player = ComputerPlayer.new(board)

      computer_player.move.should == 0
      board.move(1)
      computer_player.move.should == 3
      board.move(4)
      computer_player.move.should == 6
    end
  end
end

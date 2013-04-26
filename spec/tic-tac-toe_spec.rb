def play player_choice, input_list=nil, play_again=nil
  t = TicTacToe.new
  t.stub(:gets).and_return(*[player_choice, play_again].compact)
  t.human_player.stub(:gets).and_return(*input_list) if input_list
  t.human_player.stub(:print)
  t.human_player.stub(:puts)
  t.stub(:print)
  t.stub(:puts)
  t.main_loop
end

describe TicTacToe do
  context "#to_s" do
    it "should show initial position" do
      t = TicTacToe.new
      t.board.inspect.should == "   /   /   "
      t.board.to_s.should == <<-EOF
                     0 | 1 | 2
                    -----------
                     3 | 4 | 5
                    -----------
                     6 | 7 | 8
EOF
    end
  end

  context "#initialize" do
    it "should set board" do
      t = TicTacToe.new("XX /OX / OO")
      t.board.inspect == "XX /OX / OO"
      t.board.to_s.should == <<-EOF
                     X | X | 2
                    -----------
                     O | X | 5
                    -----------
                     6 | O | O
EOF
    end
  end

  context "play a game" do
    it "should start a game and quit" do
      play("q")
    end
    
    it "should select (1) You and quit " do
      play("1", ["q"])
    end
      
    it "should select (1) You, move 1, and quit" do
      play("1", ["1", "q"])
    end
    
    it "should select (2) Computer and quit" do
      play("2", ["q"])
    end

    it "should select (1) You, and play a complete game" do
      play("1", # I go first
        ["0", "8", "7", "2", "3"], # human moves
        "n")
        # expected computer moves: [4,1,6,5]
    end

    it "should select (2) Computer and win" do
      play("2", # Computer go first
        ["1", "q"], # human moves
        "n")
        # expected computer moves: [4,1,6,5]
    end
  end
end

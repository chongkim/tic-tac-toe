require 'player'

class HumanPlayer < Player
  def initialize board, name="You"
    super(board, name)
  end

  def prompt_for_move
    puts "#{@board.to_s}"
    begin
      print "input [0-#{board.size-1},q] (q-quit): "
      str = gets.chomp
      throw :quit if str == 'q'
    end until str =~ /\d+/ && @board.space?(str.to_i)
    str
  end

  def move
    pos = prompt_for_move
    @board.move(pos.to_i)
  end
end

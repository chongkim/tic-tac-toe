require 'player'

class HumanPlayer < Player
  def prompt_for_move
    puts "#{@board.to_s}"
    begin
      print "input [0-8,q] (q-quit): "
      str = gets.chomp
      throw :quit if str == 'q'
    end until str =~ /[0-8]/ && @board.space?(str.to_i)
    str
  end

  def move
    pos = prompt_for_move
    @board.move(pos.to_i)
  end
end

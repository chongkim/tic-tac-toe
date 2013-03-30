#!/usr/bin/env ruby

class TicTacToe
  def initialize row1="   ", row2="   ", row3="   "
    @board = "-" + row1 + row2 + row3 # the "-" is a dummy place holder so index starts at 1
    @turn = 1
    @step = 0
  end

  def show
    str = ""
    3.times do |i|
      str += "#{@board[3*i+1]}|#{@board[3*i+2]}|#{@board[3*i+3]}\n"
      str += "------\n" unless i == 2
    end
    print str
    str
  end

  def positions *list
    list.map{|n| @board[n]}.join
  end

  def prompt
    show
    puts "possible moves: #{possible_moves.inspect}"
    begin
      skip_code_str = @step == 0 ? ",s" : ""
      skip_desc_str = @step == 0 ? ", s-skip" : ""
      print "input [1-9,q#{skip_code_str}] (1 top-left, 9-lower-right, q-quit#{skip_desc_str}): "
      str = gets.chomp
      break if str =~ /[1-9]/ && @board[str.to_i] == ' '
      break if str == 'q'
      break if @step == 0 && str == 's'
    end while true
    str
  end

  def possible_moves
    (1..9).map {|i| @board[i] == ' ' ? i : nil}.compact
  end

  def evaluate
    return @evaluate if @evaluate
    lines = [positions(1,2,3), positions(4,5,6), positions(7,8,9), # across
             positions(1,4,7), positions(2,5,8), positions(3,6,9), # down
             positions(1,5,9), positions(3,5,7)] #diagonal
    @evaluate =  100-@step if lines.any? {|line| line == "xxx" }
    @evaluate = -100+@step if @evaluate.nil? && lines.any? {|line| line == "ooo" }
    @evaluate ||= 0
    return @evaluate
  end

  def move pos
    if pos
      @board[pos] = @turn == 1 ? "x" : "o"
      @turn = -@turn
      @step += 1
      @evaluate = nil
    end
    self
  end

  def unmove pos
    if pos
      @board[pos] = ' '
      @turn = -@turn
      @step -= 1
      @evaluate = nil
    end
    self
  end

  def best_moves
    possible_moves.map {|m| [deep_evaluate(m), m] }.sort { |a,b|
      t = b[0] <=> a[0];                # sort by evaluation
      t = t == 0 ? a[1] <=> b[1] : t    # secondly by move
      t*@turn
    }.map{|e| e[1]}
  end

  def deep_evaluate m=nil
    move(m)
    return evaluate if evaluate != 0
    return 0 if possible_moves.empty?

    values = []
    possible_moves.each do |m|
      values << deep_evaluate(m)
    end
    return @turn < 0 ? values.min : values.max
  ensure
    unmove(m)
  end

  def main_loop
    last_mover = nil
    while evaluate == 0 && !possible_moves.empty? && (m = prompt) != 'q'

      move(m.to_i) unless m == 's'
      last_mover = :you

      b = best_moves
      unless b.empty?
        move(b[0])
        last_mover = :computer
      end
    end
    if m != 'q'
      show
      puts evaluate == 0 ? "tie" : "Winner: #{last_mover}"
    end
  end
end

if __FILE__ == $0 then
  TicTacToe.new.main_loop
end

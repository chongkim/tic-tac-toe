#!/usr/bin/env ruby
class TicTacToe
  def initialize row1="   ", row2="   ", row3="   "
    @b = "-" + row1 + row2 + row3
    @t = 1
    @s = 0
  end
  def show
    str = ""
    3.times do |i|
      str += "#{@b[3*i+1]}|#{@b[3*i+2]}|#{@b[3*i+3]}\n"
      str += "------\n" unless i == 2
    end
    print str
    str
  end
  def positions *list
    list.map{|n| @b[n]}.join
  end
  def prompt
    show
    puts "possible moves: #{possible_moves.inspect}"
    begin
      skip_code_str = @s == 0 ? ",s" : ""
      skip_desc_str = @s == 0 ? ", s-skip" : ""
      print "input [1-9,q#{skip_code_str}] (1 top-left, 9-lower-right, q-quit#{skip_desc_str}): "
      str = gets.chomp
      break if str =~ /[1-9]/ && @b[str.to_i] == ' '
      break if str == 'q'
      break if @s == 0 && str == 's'
    end while true
    str
  end
  def possible_moves
    (1..9).map {|i| @b[i] == ' ' ? i : nil}.compact
  end
  def evaluate
    lines = [positions(1,2,3), positions(4,5,6), positions(7,8,9),
             positions(1,4,7), positions(2,5,8), positions(3,6,9),
             positions(1,5,9), positions(3,5,7)] #diagonal
    return  100-@s if lines.any? {|line| line == "xxx" }
    return -100+@s if lines.any? {|line| line == "ooo" }
    return 0
  end
  def move pos
    @b[pos] = @t == 1 ? "x" : "o"
    @t = -@t
    @s += 1
    self
  end
  def unmove pos
    @b[pos] = ' '
    @t = -@t
    @s -= 1
    self
  end
  def best_moves
    list = possible_moves.map do |m|
      move(m)
      e = deep_evaluate
      unmove(m)
      [e, m]
    end
    list.sort { |a,b|
      t = b[0] <=> a[0];
      t = t == 0 ? a[1] <=> b[1] : t
      t*@t
    }.map{|e| e[1]}
  end
  def deep_evaluate
    return evaluate if evaluate != 0
    return 0 if possible_moves.empty?
    values = []
    possible_moves.each do |m|
      move(m)
      values << deep_evaluate
      unmove(m)
    end
    return @t < 0 ? values.min : values.max
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

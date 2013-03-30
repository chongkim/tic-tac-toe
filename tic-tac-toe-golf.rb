#!/usr/bin/env ruby
class TicTacToe
  def initialize row1="   ", row2="   ", row3="   "
    @t, @s, @b = 1, 0, "-" + row1 + row2 + row3
  end
  def to_s
    str = ""
    3.times do |i|
      str += "#{@b[3*i+1]}|#{@b[3*i+2]}|#{@b[3*i+3]}\n"
      str += "------\n" if i != 2
    end
    str
  end
  def positions *list
    list.map{|n| @b[n]}.join
  end
  def prompt
    puts "#{to_s}possible moves: #{possible_moves.inspect}"
    begin
      skip_code_str = @s == 0 ? ",s" : ""
      skip_desc_str = @s == 0 ? ", s-skip" : ""
      print "input [1-9,q#{skip_code_str}] (1 top-left, 9-lower-right, q-quit#{skip_desc_str}): "
      str = gets.chomp
    end while !(str =~ /[1-9]/ && @b[str.to_i] == ' ') && str != 'q' && !(@s == 0 && str == 's')
    str
  end
  def possible_moves
    (1..9).to_a.delete_if {|i| @b[i] != ' '}
  end
  def evaluate
    lines = [positions(1,2,3), positions(4,5,6), positions(7,8,9),
             positions(1,4,7), positions(2,5,8), positions(3,6,9),
             positions(1,5,9), positions(3,5,7)] #diagonal
    @e =  100-@s if @e.nil? && lines.any? {|line| line == "xxx" }
    @e = -100+@s if @e.nil? && lines.any? {|line| line == "ooo" }
    @e ||= 0
    return @e
  end
  def move pos
    @t, @s, @e, @b[pos] = -@t, @s+1, nil, "o x"[@t+1] if pos
    self
  end
  def unmove pos
    @t, @s, @e, @b[pos] = -@t, @s-1, nil, ' ' if pos
    self
  end
  def best_moves
    list = possible_moves.map do |m|
      [deep_evaluate(m), m]
    end
    list.sort { |a,b|
      t = b[0] <=> a[0];
      t = t == 0 ? a[1] <=> b[1] : t
      t*@t
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
    return @t < 0 ? values.min : values.max
  ensure
    unmove(m)
  end
  def main_loop
    last_mover = nil
    while evaluate == 0 && !possible_moves.empty? && (m = prompt) != 'q'
      move(m.to_i) if m != 's'
      last_mover = :you
      b = best_moves
      if !b.empty?
        move(b[0])
        last_mover = :computer
      end
    end
    if m != 'q'
      puts "#{to_s}#{evaluate == 0 ? "tie" : "Winner: #{last_mover}"}"
    end
  end
end
if __FILE__ == $0 then
  TicTacToe.new.main_loop
end

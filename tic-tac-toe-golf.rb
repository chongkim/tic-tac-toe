#!/usr/bin/env ruby
class TicTacToe
  def initialize row1="   ", row2="   ", row3="   "; @t, @s, @b = 1, 0, "-" + row1 + row2 + row3; end
  def to_s; @b[1..9].scan(/.../).map{|r| r.scan(/./).join('|')}.join("\n------\n") + "\n"; end
  def p *list; list.map{|n| @b[n]}.join; end
  alias_method :positions, :p
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
  def possible_moves; (1..9).to_a.delete_if {|i| @b[i] != ' '}; end
  def evaluate
    lines = [p(1,2,3),p(4,5,6),p(7,8,9),p(1,4,7),p(2,5,8),p(3,6,9),p(1,5,9),p(3,5,7)]
    @e =  100-@s if @e.nil? && lines.any? {|line| line == "xxx" }
    @e = -100+@s if @e.nil? && lines.any? {|line| line == "ooo" }
    @e ||= 0
    return @e
  end
  def move pos; @t, @s, @e, @b[pos] = -@t, @s+1, nil, "o x"[@t+1] if pos; self; end
  def unmove pos; @t, @s, @e, @b[pos] = -@t, @s-1, nil, ' ' if pos; self;   end
  def best_moves; possible_moves.map {|m| [deep_evaluate(m), m] }.sort{|a,b| (10*(b[0]<=>a[0])+(a[1]<=>b[1]))*@t}.map{|e| e[1]}; end
  def deep_evaluate m=nil
    move(m)
    return evaluate if evaluate != 0
    return 0 if possible_moves.empty?
    possible_moves.map {|m| deep_evaluate(m) }.send(@t < 0 ? :min : :max)
  ensure
    unmove(m)
  end
  def main_loop
    while evaluate == 0 && !possible_moves.empty? && (m = prompt) != 'q'
      move(m.to_i) if m != 's'
      @last_mover = :you
      b = best_moves
      if !b.empty?
        move(b[0])
        @last_mover = :computer
      end
    end
    puts "#{to_s}#{evaluate == 0 ? "tie" : "Winner: #{@last_mover}"}" if m != 'q'
  end
end
TicTacToe.new.main_loop if __FILE__ == $0

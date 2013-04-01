#!/usr/bin/env ruby

class TicTacToe
  def initialize row1="   ", row2="   ", row3="   "
    @board = "-" + row1 + row2 + row3 # the "-" is a dummy place holder so index starts at 1
    @turn = 1
    @step = 0
    @possible_moves = nil
    @move_list = []
  end

  def to_s
    str = ""
    3.times do |i|
      str += "#{@board[3*i+1]}|#{@board[3*i+2]}|#{@board[3*i+3]}\n"
      str += "------\n" unless i == 2
    end
    str
  end

  def positions *list
    list=(1..9).to_a if list.empty?
    list.map{|n| @board[n]}.join
  end

  def prompt
    puts "#{to_s}possible moves: #{possible_moves.inspect}"
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
    return @possible_moves if @possible_moves
    list = (1..9).map {|i| @board[i] == ' ' ? i : nil}.compact
    @possible_moves = []
    s = symmetries
    list.each do |m|
      new_m = s.map{|trans| transform(m, trans)}.sort[0]
      @possible_moves << new_m if !@possible_moves.include?(new_m)
    end
    @possible_moves
  end

  def evaluate
    return @evaluate if @evaluate
    lines = [positions(1,2,3), positions(4,5,6), positions(7,8,9), # across
             positions(1,4,7), positions(2,5,8), positions(3,6,9), # down
             positions(1,5,9), positions(3,5,7)] # diagonal
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
      @possible_moves = nil
      @move_list << pos
    end
    self
  end

  def unmove pos
    if pos
      @board[pos] = ' '
      @turn = -@turn
      @step -= 1
      @evaluate = nil
      @possible_moves = nil
      @move_list.pop
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
      puts "#{to_s}#{evaluate == 0 ? "tie" : "Winner: #{last_mover}"}"
    end
  end

  def to_xy pos
    i = pos-1
    ix = i%3
    iy = i/3
    [ix-1,1-iy]
  end

  def from_xy *coord
    (coord[0]+1 + (1-coord[1])*3) + 1
  end

  # these are just simple matrix transformations
  def transform pos, trans
    ix, iy = to_xy(pos)
    case trans
    when :r1
      # [1 0]
      # [0 1]  identity so don't do anything
      pos

    when :r2
      # [0 -1][ix]   [-iy]
      # [1  0][iy] = [ ix]
      from_xy(-iy, ix)

    when :r3
      # [-1  0][ix]   [-ix]
      # [ 0 -1][iy] = [-iy]
      from_xy(-ix, -iy)

    when :r4
      # [ 0 1][ix]   [ iy]
      # [-1 0][iy] = [-ix]
      from_xy(iy, -ix)

    when :h
      # [1  0][ix]   [ ix]
      # [0 -1][iy] = [-iy]
      from_xy(ix, -iy)
    when :v
      # [-1 0][ix]   [-ix]
      # [ 0 1][iy] = [ iy]
      from_xy(-ix, iy)
    when :d1
      # [ 0 -1][ix]   [-iy]
      # [-1  0][iy] = [-ix]
      from_xy(-iy, -ix)
    when :d2
      # [0 1][ix]   [iy]
      # [1 0][iy] = [ix]
      from_xy(iy, ix)
    else
      raise "don't understand #{trans}"
    end
  end

  def transform_board trans
    test_board = "-"+" "*9
    (1..9).each do |pos|
      test_board[transform(pos, trans)] = @board[pos]
    end
    test_board
  rescue
    raise
  end

  def symmetries
    [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2].delete_if { |trans| r = transform_board(trans) != @board }
  end
end

TicTacToe.new.main_loop if __FILE__ == $0

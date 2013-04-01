#!/usr/bin/env ruby

class TicTacToe
  def initialize row1="   ", row2="   ", row3="   "
    @board = "-" + row1 + row2 + row3 # the "-" is a dummy place holder so index starts at 1
    @turn = 1
    @step = 0
    @possible_moves = nil
    @move_list = []
    @indent = 20
  end

  def cell_string pos
    cell = @board[pos]
    cell == ' ' ? "\x1b[30;1m#{pos}\x1b[0m" : cell
  end

  def to_s
    str = ""
    3.times do |i|
      str += " "*@indent + " #{cell_string(3*i+1)} | #{cell_string(3*i+2)} | #{cell_string(3*i+3)}\n"
      str += " "*@indent + "-----------\n" unless i == 2
    end
    str
  end

  def positions *list
    list=(1..9).to_a if list.empty?
    list.map{|n| @board[n]}
  end

  def prompt_for_move
    puts "#{to_s}"
    begin
      print "input [1-9,q] (1 top-left, 9-lower-right, q-quit): "
      str = gets.chomp
      break if str =~ /[1-9]/ && @board[str.to_i] == ' '
      throw :quit if str == 'q'
    end while true
    str
  end

  def possible_moves
    return @possible_moves if @possible_moves
    @possible_moves = (1..9).map {|i| @board[i] == ' ' ? i : nil}.compact
    @possible_moves
  end

  def possible_moves_minus_symmetry
    list = []
    possible_moves.each do |m|
      new_m = symmetries.map{|trans| transform(m, trans)}.sort[0]
      list << new_m if !list.include?(new_m)
    end
    list
  end

  def evaluate
    return @evaluate if @evaluate
    lines = [[1,2,3], [4,5,6], [7,8,9], # across
             [1,4,7], [2,5,8], [3,6,9], # down
             [1,5,9], [3,5,7]] # diagonal
    lines.each do |line|
      sequence = positions(*line)
      return (@evaluate =  100-@step) if sequence == ["x","x","x"]
      return (@evaluate = -100+@step) if sequence == ["o","o","o"]
    end
    @evaluate = 0
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
    possible_moves_minus_symmetry.map {|m| [deep_evaluate(m), m] }.sort { |a,b|
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

  def prompt_who_goes_first
    ans = nil
    while true
      puts
      puts "Choose who plays first"
      puts " [1] - You"
      puts " [2] - Computer"
      puts
      puts " [q[ - quit game"
      puts
      print "[1,2,q]: "
      case gets.chomp
      when "q"
        throw :quit
      when "1"
        return :you
      when "2"
        return :computer
      end
    end
  end

  def has_open_space?
    @board =~ /[ 0-9]/
  end

  def start_show_thinking
    @thinking_thread_continue = true
    @thinking_thread = Thread.new do
      while @thinking_thread_continue
        sleep 0.5
        print "."
        # $stdout.flush
      end
    end
  end

  def stop_show_thinking
    @thinking_thread_continue = false
    @thinking_thread.join
    puts
  end

  def prompt_for_new_game
    begin
      print "Do you want to play again? [y,n]: "
      ans = gets.chomp
    end until ans == 'y' || ans == 'n'
    ans
  end

  def main_loop
    puts "Welcome to TicTacToe"
    catch (:quit) do
      begin
        last_mover = nil
        if prompt_who_goes_first == :computer then
          start_show_thinking
          move(best_moves.first)
          stop_show_thinking
          last_mover = :computer
        end

        while evaluate == 0 && !possible_moves.empty?
          m = prompt_for_move
          move(m.to_i) unless m == 's'
          last_mover = :you

          if has_open_space?
            start_show_thinking
            move(best_moves.first)
            stop_show_thinking
            last_mover = :computer
          end
        end
        puts "#{to_s}#{evaluate == 0 ? "tie" : "Winner: #{last_mover}"}"
        initialize
      end until prompt_for_new_game == 'n'
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
    [:r1, :r2, :r3, :r4, :h, :v, :d1, :d2].keep_if { |trans| transform_board(trans) == @board }
  end
end

TicTacToe.new.main_loop if File.basename(__FILE__) == File.basename($0)

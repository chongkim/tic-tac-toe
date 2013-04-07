#!/usr/bin/env ruby

class Board

  TRANS_MAP = {
    :r1 => [nil, 1,2,3, 4,5,6, 7,8,9],
    :r2 => [nil, 7,4,1, 8,5,2, 9,6,3],
    :r3 => [nil, 9,8,7, 6,5,4, 3,2,1],
    :r4 => [nil, 3,6,9, 2,5,8, 1,4,7],
    :h => [nil, 7,8,9, 4,5,6, 1,2,3],
    :v => [nil, 3,2,1, 6,5,4, 9,8,7],
    :d1 => [nil, 1,4,7, 2,5,8, 3,6,9],
    :d2 => [nil, 9,6,3, 8,5,2, 7,4,1]
  }

  def reset_memo
    @evaluate = nil
    @possible_moves = nil
    @symmetries = nil
  end

  def initialize row1="   ", row2="   ", row3="   "
    @data = "-" + row1 + row2 + row3 # the "-" is a dummy place holder so index starts at 1
    @indent = 20
    @turn = 1
    @step = 0
    @move_list = []
    reset_memo
  end

  def cell_string pos
    cell = self[pos]
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

  def possible_moves
    @possible_moves ||= (1..9).to_a.keep_if {|i| @data[i] == ' ' }
  end

  def evaluate
    return @evaluate if @evaluate
    lines = [[1,2,3], [4,5,6], [7,8,9], # across
             [1,4,7], [2,5,8], [3,6,9], # down
             [1,5,9], [3,5,7]] # diagonal
    lines.each do |line|
      sequence = line.map{|pos| @data[pos]}
      return (@evaluate =  100-@step) if sequence == ["x","x","x"]
      return (@evaluate = -100+@step) if sequence == ["o","o","o"]
    end
    @evaluate = 0
    return @evaluate
  end

  def move pos
    if pos
      @data[pos] = @turn == 1 ? "x" : "o"
      @turn = -@turn
      @step += 1
      @move_list << pos
      reset_memo
    end
  end

  def unmove pos
    if pos
      @data[pos] = ' '
      @turn = -@turn
      @step -= 1
      @move_list.pop
      reset_memo
    end
  end

  def best_moves
    # sort by evaluation then by move
    possible_moves_minus_symmetry.map {|m| [deep_evaluate(m), m] }.sort { |a,b|
      ((b[0] <=> a[0])*2 + (a[1] <=> b[1]))*@turn
    }.map{|e| e[1]}
  end

  def deep_evaluate m=nil
    move(m)
    return evaluate if evaluate != 0
    return 0 if possible_moves.empty?

    values = possible_moves.map { |m| deep_evaluate(m) }
    return @turn < 0 ? values.min : values.max
  ensure
    unmove(m)
  end

  def [](pos)
    @data[pos]
  end

  def []=(pos, val)
    @data[pos] = val
  end

  def has_open_space?
    @data.index(' ')
  end

  def transform trans, pos
    TRANS_MAP[trans][pos]
  end

  def symmetric? trans
    (1..9).all? { |pos| @data[pos] == @data[transform(trans, pos)] }
  end

  def symmetries
    @symmetries ||= TRANS_MAP.keys.keep_if { |trans| symmetric?(trans) }
  end

  # see symmetries of current board e.g. rot2
  # for each possible move apply symmetry.  that is your group
  def symmetry_equivalent_classes
    result = []
    move_list = possible_moves.dup
    while !move_list.empty?
      pos = move_list.first
      group = symmetries.map { |trans| transform(trans, pos) }.uniq
      group.each do |pos|
        move_list.delete(pos)
      end
      result << group
    end
    result
  end

  def possible_moves_minus_symmetry
    symmetry_equivalent_classes.map(&:first)
  end

end
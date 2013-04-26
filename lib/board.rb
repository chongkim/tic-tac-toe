#!/usr/bin/env ruby

class Board

  attr_reader :step, :turn

  def initialize position="   /   /   "
     # the "-" is a dummy place holder so index starts at 1
    @data = position.delete("/").chars.map(&:to_sym)
    @indent = 20
    @turn = 1
    @step = 0
    @move_list = []
    reset_memo
    evaluate_initial_position
  end

  def evaluate_initial_position
    lines = [[0,1,2], [3,4,5], [6,7,8], # across
             [0,3,6], [1,4,7], [2,5,8], # down
             [0,4,8], [2,4,6]] # diagonal
    lines.each do |line|
      sequence = line.map{|pos| @data[pos]}
      return (@evaluate =  100-@step) if sequence == [:x,:x,:x]
      return (@evaluate = -100+@step) if sequence == [:o,:o,:o]
    end
    return @evaluate = nil
  end

  def reset_memo
    @evaluate = nil
    @possible_moves = nil
    @piece = nil
    @has_win = nil
    @last_move = nil
  end

  def inspect
    str = ""
    @data.each_with_index do |c, i|
      str << c.to_s
      str << '/' if i % 3 == 2 && i != 8
    end
    str
  end

  def cell_string pos
    self[pos] == :' ' ? pos : self[pos]
  end

  def to_s
    str = ""
    3.times do |i|
      str += " "*@indent + " #{cell_string(3*i+0)} | #{cell_string(3*i+1)} | #{cell_string(3*i+2)}\n"
      str += " "*@indent + "-----------\n" unless i == 2
    end
    str
  end

  def possible_moves
    @possible_moves ||= (0..8).to_a.keep_if {|i| @data[i] == :' ' }
  end

  def evaluate
    return @evaluate if @evaluate
    # win is determined by the last player to move thus the -@turn
    return @evaluate = (100-@step)*(-@turn) if @has_win
    return @evaluate = 0
  end

  def piece
    @piece ||= @turn == 1 ? :x : :o
  end

  def last_move
    @last_move ||= @move_list.last
  end

  def check_for_win
    last_piece = piece == :x ? :o : :x
    row = last_move / 3
    col = last_move % 3
    line = (0..2).to_a
    @has_win   = line.all? { |i| @data[row*3+i]   == last_piece }
    @has_win ||= line.all? { |i| @data[i*3+col]   == last_piece }
    @has_win ||= line.all? { |i| @data[i*3+i]     == last_piece } if row == col
    @has_win ||= line.all? { |i| @data[(2-i)*3+i] == last_piece } if 2-row == col
  end

  def move pos
    @data[pos] = piece
    @turn = -@turn
    @step += 1
    @move_list << pos
    reset_memo
    check_for_win
  end

  def unmove pos
    if pos
      @data[pos] = :' '
      @turn = -@turn
      @step -= 1
      @move_list.pop
      reset_memo
    end
  end

  def [](pos)
    @data[pos]
  end

  def space? pos
    @data[pos] == :' '
  end
end

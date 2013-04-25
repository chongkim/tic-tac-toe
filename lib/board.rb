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
  end

  def reset_memo
    @evaluate = nil
    @possible_moves = nil
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
    lines = [[0,1,2], [3,4,5], [6,7,8], # across
             [0,3,6], [1,4,7], [2,5,8], # down
             [0,4,8], [2,4,6]] # diagonal
    lines.each do |line|
      sequence = line.map{|pos| @data[pos]}
      return (@evaluate =  100-@step) if sequence == [:x,:x,:x]
      return (@evaluate = -100+@step) if sequence == [:o,:o,:o]
    end
    @evaluate = 0
    return @evaluate
  end

  def move pos
    @data[pos] = @turn == 1 ? :x : :o
    @turn = -@turn
    @step += 1
    @move_list << pos
    reset_memo
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
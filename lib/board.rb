#!/usr/bin/env ruby
require 'piece'

class Board

  attr_reader :step, :turn, :move_list, :dim, :size

  def initialize position_or_dim="   /   /   "
    if Fixnum === position_or_dim
      @dim = position_or_dim
      @size = @dim*@dim
      @data = Array.new(@size).map { Piece.new(' ') }
    else
      @data = position_or_dim.delete("/").chars.map{|char| Piece.new(char) }
      @size = @data.size
      @dim = Math.sqrt(@data.size).to_i
      raise "format of position is not a square" if @dim*@dim != @data.size
    end
    @indent = 20
    @turn = 1
    @step = 0
    @move_list = []
    reset_memo
    evaluate_initial_position
  end

  def row_lines
    lines = []
    @dim.times do |row|
      lines << (0..(@dim - 1)).to_a.map { |col| row*@dim + col }
    end
    lines
  end

  def column_lines
    lines = []
    @dim.times do |col|
      lines << (0..(@dim - 1)).to_a.map { |row| row*@dim + col }
    end
    lines
  end

  def diagonal_lines
    lines = []
    lines << (0..(@dim - 1)).to_a.map { |i| i*@dim + i }
    lines << (0..(@dim - 1)).to_a.map { |i| i*@dim + (@dim - 1 - i) }
  end

  def evaluate_initial_position
    lines = row_lines + column_lines + diagonal_lines
    lines.each do |line|
      sequence = line.map{|pos| @data[pos]}
      return (@evaluate =  100-@step) if sequence.all? { |piece| piece == :x }
      return (@evaluate = -100+@step) if sequence.all? { |piece| piece == :o }
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
    @data.each_with_index do |piece, i|
      str << '/' if i % @dim == 0 && i != 0
      str << piece.to_s
    end
    str
  end

  def cell_string pos
    fmt = " %#{@dim < 4 ? 1 : 2}s "
    content = self[pos] == :' ' ? pos : self[pos]
    fmt % content
  end

  def to_s
    indent_str = " " * @indent
    separator = (@dim < 4 ? "---" : "----") * @dim + "-" * (@dim-1)
    (0..(@dim-1)).to_a.map { |row|
      indent_str + (0..(@dim-1)).to_a.map { |col| cell_string(@dim*row + col) }.join("|")
    }.join("\n#{indent_str}#{separator}\n") + "\n"
  end

  def possible_moves
    @possible_moves ||= (0..(@size*@size)).to_a.keep_if {|i| @data[i] == :' ' }
  end

  def evaluate
    return @evaluate if @evaluate

    # win is determined by the last player to move thus the -@turn
    @evaluate = (100-@step)*(-@turn) if @has_win
    @evaluate ||= 0
    puts "#{@move_list.inspect} - #{@evaluate}" if $debug
    return @evaluate
  end

  def piece
    @piece ||= @turn == 1 ? :X : :O
  end

  def other_piece
    piece == :X ? :O : :X
  end

  def last_move
    @last_move ||= @move_list.last
  end

  def check_for_win
    last_move = @move_list.last
    last_piece = other_piece
    row = last_move / dim
    col = last_move % dim
    line = (0..(dim-1)).to_a
    @has_win   = line.all? { |i| @data[row*dim+i]   == last_piece }
    @has_win ||= line.all? { |i| @data[i*dim+col]   == last_piece }
    @has_win ||= line.all? { |i| @data[i*dim+i]     == last_piece } if row == col
    @has_win ||= line.all? { |i| @data[(dim-1-i)*dim+i] == last_piece } if dim-1-row == col
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

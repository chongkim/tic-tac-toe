require 'matrix'

class Symmetry
  attr_reader :board, :evaluations

  def initialize board
    @board = board
    @trans_map = {}
    @evaluations = {}
  end

  def set_board board
    @board = board
  end

  # The formula comes from the fact we want to transform the tic-tac-toe grid
  # with respect to it's center but we want to avoid using floating points.
  # Let d be the upper right corner, whose coordinates are [board.dim-1, board.dim-1], 
  # e.g. 3x3 grid would be [3,3].  Let c be the center vector, which is d/2.
  #   (vector-c)*matrix + c => vector*matrix + (-d*matrix + d) / 2.
  # Each x or y component will either be double their value or 0, so dividing
  # by 2 will result in a new vector with Fixnum components.
  def calculate_transform(matrix, pos)
    vector = Matrix[[pos % board.dim, pos / board.dim]]
    d = Matrix[[ board.dim-1, board.dim-1 ]]
    new_vector = (vector*matrix + (d-d*matrix)/2).row(0)
    new_pos = new_vector[1]*board.dim + new_vector[0]
  end

  def trans_map
    return @trans_map[board.dim] if @trans_map[board.dim]

    matrices = {
      :r1 => Matrix[[ 1,  0], [ 0,  1]],
      :r2 => Matrix[[ 0,  1], [-1,  0]],
      :r3 => Matrix[[-1,  0], [ 0, -1]],
      :r4 => Matrix[[ 0, -1], [ 1,  0]],
      :h  => Matrix[[ 1,  0], [ 0, -1]],
      :v  => Matrix[[-1,  0], [ 0,  1]],
      :d1 => Matrix[[ 0, -1], [-1,  0]],
      :d2 => Matrix[[ 0,  1], [ 1,  0]],
    }

    @trans_map[board.dim] = {}
    matrices.each_pair do |trans, matrix|
      @trans_map[board.dim][trans] = (0..(board.size-1)).to_a.map { |pos|
        calculate_transform(matrix, pos)
      }
    end
    @trans_map[board.dim]
  end

  def transform trans, pos
    trans_map[trans][pos]
  end

  def symmetric? trans
    (0..(board.size-1)).all? { |pos| @board[pos] == @board[transform(trans, pos)] }
  end

  def symmetries
    trans_map.keys.keep_if { |trans| symmetric?(trans) }
  end

  # Get symmetries of current board. Group symmetrical moves into equivalence classes
  def symmetry_equivalent_classes
    result = []
    move_list = board.possible_moves.dup
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

  def transform_key trans
    key = ""
    board.size.times do |pos|
      key << "/" if pos != 0 && pos % board.dim == 0
      key << board[transform(trans, pos)].to_s
    end
    key
  end

  def lookup_symmetrical_evaluation
    trans_map.keys.each do |trans|
      val = evaluations[transform_key(trans)]
      return val if val
    end
    return nil
  end
end

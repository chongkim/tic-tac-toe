require 'player'
require 'board'
require 'matrix'

class ComputerPlayer < Player
  attr_reader :board

  def initialize board, name="Computer"
    super(board, name)
    @semaphore = Mutex.new
    @trans_map = {}
    reset_memo
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

  def set_board board
    super(board)
    reset_memo

  end

  def reset_memo
    @memoized_position = {}
  end

  def start_show_thinking
    @thinking_thread_continue = true
    @thinking_thread_did_print = false
    @thinking_thread = Thread.new do
      while @thinking_thread_continue
        sleep 0.5
        if @thinking_thread_continue
          @semaphore.synchronize do
            @thinking_thread_did_print = true
            print "." if @thinking_thread_continue
          end
        end
      end
    end
  end

  def stop_show_thinking
    @thinking_thread_continue = false
    @semaphore.synchronize do
      puts if @thinking_thread_did_print
    end
    @thinking_thread_did_print = false
    @thinking_thread.join
  end

  # makes a move and returns the move
  def move
    start_show_thinking
    @board.move(best_moves.first)
    stop_show_thinking
    board.last_move
  end

  def best_moves
    # sort by evaluation then by move
    possible_moves_minus_symmetry.map {|m| [deep_evaluate(m), m] }.sort { |a,b|
      ((b[0] <=> a[0])*2 + (a[1] <=> b[1]))*board.turn
    }.map{|e| e[1]}
  end

  def memoized_position value=nil
    key = board.inspect

    stored_value = @memoized_position[key]
    return stored_value if stored_value

    return @memoized_position[key] = value if value

    return nil
  end

  def deep_evaluate m=nil
    board.move(m) if m
    return memoized_position if memoized_position
    return memoized_position(board.evaluate) if board.evaluate != 0
    return memoized_position(0) if board.possible_moves.empty?

    # it's faster to just do all the moves than than to calculate symmetries for 3x3 and less
    moves = board.dim < 4 ? board.possible_moves : possible_moves_minus_symmetry
    values = moves.map { |m| deep_evaluate(m) }
    
    return memoized_position(board.turn < 0 ? values.min : values.max)
  ensure
    board.unmove(m) if m
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

  # see symmetries of current board e.g. rot2
  # for each possible move apply symmetry.  that is your group
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
end

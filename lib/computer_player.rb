require 'player'
require 'board'

class ComputerPlayer < Player
  attr_reader :board

  TRANS_MAP = {
    :r1 => [0,1,2, 3,4,5, 6,7,8],
    :r2 => [6,3,0, 7,4,1, 8,5,2],
    :r3 => [8,7,6, 5,4,3, 2,1,0],
    :r4 => [2,5,8, 1,4,7, 0,3,6],
    :h => [6,7,8, 3,4,5, 0,1,2],
    :v => [2,1,0, 5,4,3, 8,7,6],
    :d1 => [0,3,6, 1,4,7, 2,5,8],
    :d2 => [8,5,2, 7,4,1, 6,3,0]
  }

  def initialize *args
    super(*args)
    @semaphore = Mutex.new
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

  def move
    start_show_thinking
    @board.move(best_moves.first)
    stop_show_thinking
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

    values = board.possible_moves.map { |m| deep_evaluate(m) }
    return memoized_position(board.turn < 0 ? values.min : values.max)
  ensure
    board.unmove(m) if m
  end

  def transform trans, pos
    TRANS_MAP[trans][pos]
  end

  def symmetric? trans
    (0..8).all? { |pos| @board[pos] == @board[transform(trans, pos)] }
  end

  def symmetries
    TRANS_MAP.keys.keep_if { |trans| symmetric?(trans) }
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

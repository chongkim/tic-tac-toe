require 'player'
require 'board'
require 'symmetry'

class ComputerPlayer < Player
  attr_reader :board, :symmetry

  def initialize board, name="Computer"
    super(board, name)
    @symmetry = Symmetry.new(board)
    @semaphore = Mutex.new
    @trans_map = {}
    reset_memo
  end

  def set_board board
    super(board)
    symmetry.set_board(board)
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
    symmetry.possible_moves_minus_symmetry.map {|m| [deep_evaluate(m), m] }.sort { |a,b|
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

    # check symmetry lookup table
    lookup_evaluation = symmetry.lookup_symmetrical_evaluation
    return memoized_position(lookup_evaluation) if lookup_evaluation

    # note: it's faster to just do all the moves than than to calculate symmetries for 3x3 and less
    moves = board.dim < 4 ? board.possible_moves : symmetry.possible_moves_minus_symmetry
    values = moves.map { |m| deep_evaluate(m) }
    
    return memoized_position(board.turn < 0 ? values.min : values.max)
  ensure
    board.unmove(m) if m
  end
end

require 'player'

class ComputerPlayer < Player
  attr_reader :board

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

  def initialize *args
    super(*args)
    reset_memo
  end

  def reset_memo
    @symmetries = nil
  end

  def start_show_thinking
    @thinking_thread_continue = true
    @thinking_thread_did_print = false
    @thinking_thread = Thread.new do
      while @thinking_thread_continue
        sleep 0.5
        if @thinking_thread_continue
          @thinking_thread_did_print = true
          print "."
        end
      end
    end
  end

  def stop_show_thinking
    puts if @thinking_thread_did_print
    @thinking_thread_did_print = false
    @thinking_thread_continue = false
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

  def deep_evaluate m=nil
    board.move(m) if m
    return board.evaluate if board.evaluate != 0
    return 0 if board.possible_moves.empty?

    values = board.possible_moves.map { |m| deep_evaluate(m) }
    return board.turn < 0 ? values.min : values.max
  ensure
    board.unmove(m) if m
  end

  def transform trans, pos
    TRANS_MAP[trans][pos]
  end

  def symmetric? trans
    (1..9).all? { |pos| @board[pos] == @board[transform(trans, pos)] }
  end

  def symmetries
    @symmetries ||= TRANS_MAP.keys.keep_if { |trans| symmetric?(trans) }
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

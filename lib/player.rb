#!/usr/bin/env ruby

class Player
  attr_accessor :name
  def initialize board, name=""
    @board = board
    @name = name
  end
end

class HumanPlayer < Player
  def prompt_for_move
    puts "#{@board.to_s}"
    begin
      print "input [1-9,q] (1 top-left, 9-lower-right, q-quit): "
      str = gets.chomp
      throw :quit if str == 'q'
    end until str =~ /[1-9]/ && @board[str.to_i] == ' '
    str
  end

  def move
    pos = prompt_for_move
    @board.move(pos.to_i)
  end
end

class ComputerPlayer < Player
  def start_show_thinking
    @thinking_thread_continue = true
    @thinking_thread = Thread.new do
      while @thinking_thread_continue
        sleep 0.5
        print "." if @thinking_thread_continue
      end
    end
  end

  def stop_show_thinking
    @thinking_thread_continue = false
    @thinking_thread.join
    puts
  end

  def move
    start_show_thinking
    @board.move(@board.best_moves.first)
    stop_show_thinking
  end
end

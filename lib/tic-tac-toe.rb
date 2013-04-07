#!/usr/bin/env ruby

require 'board'

class TicTacToe

  def initialize row1="   ", row2="   ", row3="   "
    @board = Board.new row1, row2, row3
  end

  def to_s
    @board.to_s
  end

  def prompt_for_move
    puts "#{to_s}"
    begin
      print "input [1-9,q] (1 top-left, 9-lower-right, q-quit): "
      str = gets.chomp
      throw :quit if str == 'q'
    end until str =~ /[1-9]/ && @board[str.to_i] == ' '
    str
  end

  def prompt_who_goes_first
    ans = nil
    while true
      puts
      puts "Choose who plays first"
      puts " [1] - You"
      puts " [2] - Computer"
      puts
      puts " [q[ - quit game"
      puts
      print "[1,2,q]: "
      case gets.chomp
      when "q"
        throw :quit
      when "1"
        return :you
      when "2"
        return :computer
      end
    end
  end

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

  def prompt_for_new_game
    begin
      print "Do you want to play again? [y,n]: "
      ans = gets.chomp
    end until "yn".include?(ans)
    ans
  end

  def best_move
    @board.best_moves.first
  end

  def move pos
    @board.move(pos)
  end

  def main_loop
    puts "Welcome to TicTacToe"
    catch (:quit) do
      begin
        last_mover = nil
        if prompt_who_goes_first == :computer then
          start_show_thinking
          move(best_move)
          stop_show_thinking
          last_mover = :computer
        end

        while @board.evaluate == 0 && !@board.possible_moves.empty?
          pos = prompt_for_move
          move(pos.to_i)
          last_mover = :you

          if !@board.possible_moves.empty?
            start_show_thinking
            move(best_move)
            stop_show_thinking
            last_mover = :computer
          end
        end
        puts "#{to_s}#{@board.evaluate == 0 ? "tie" : "Winner: #{last_mover}"}"
        initialize
      end until prompt_for_new_game == 'n'
    end
  end
end

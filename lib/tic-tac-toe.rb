#!/usr/bin/env ruby

require 'board'
require 'player'

class TicTacToe
  attr_accessor :human_player, :computer_player

  def initialize row1="   ", row2="   ", row3="   "
    @board = Board.new row1, row2, row3
    @human_player = HumanPlayer.new(@board)
    @computer_player = ComputerPlayer.new(@board)
  end

  def to_s
    @board.to_s
  end

  def prompt_who_goes_first
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
        return [@human_player, @computer_player]
      when "2"
        return [@computer_player, @human_player]
      end
    end
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

  def main_loop
    puts "Welcome to TicTacToe"
    catch (:quit) do
      begin
        player1, player2 = prompt_who_goes_first

        while @board.evaluate == 0 && !@board.possible_moves.empty?
          player1.move
          player2.move if !@board.possible_moves.empty?
        end

        puts "#{to_s}#{@board.evaluate == 0 ? "tie" : "Winner: #{last_mover}"}"
        initialize
      end until prompt_for_new_game == 'n'
    end
  end
end

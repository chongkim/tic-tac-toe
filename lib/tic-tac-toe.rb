#!/usr/bin/env ruby

require 'board'
require 'human_player'
require 'computer_player'

class TicTacToe
  attr_accessor :human_player, :computer_player, :board

  def initialize board=nil
    if board
      @board = board
    end
    @human_player = HumanPlayer.new(board)
    @computer_player = ComputerPlayer.new(board)
  end

  def prompt_for_board
    while true
      puts
      puts "What board do you want to play with?"
      puts "  [1] - 3x3"
      puts "  [2] - 4x4"
      puts
      puts "  [q] - quit game"
      print "[1,2,q]: "
      board = nil
      case gets.chomp
      when "q"
        throw :quit
      when "1"
        board = Board.new
      when "2"
        board = Board.new(4)
      end
      @human_player.set_board(board)
      @computer_player.set_board(board)
      @board = board
      return board
    end
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
    end until "ynq".include?(ans)
    ans
  end

  def main_loop
    puts "Welcome to TicTacToe"
    catch (:quit) do
      begin
        @board = prompt_for_board
        players = prompt_who_goes_first
        player_index = 1
        while @board.evaluate == 0 && !@board.possible_moves.empty?
          player_index = 1 - player_index
          players[player_index].move
        end

        puts "#{board.to_s}#{@board.evaluate == 0 ? "tie" : "Winner: #{players[player_index].name}"}"
        initialize
      end until "nq".include?(prompt_for_new_game)
    end
  end
end

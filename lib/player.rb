#!/usr/bin/env ruby

class Player
  attr_accessor :name, :board
  def initialize board, name=""
    @board = board
    @name = name
  end
end

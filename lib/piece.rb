class Piece
  attr_reader :symbol

  def initialize char
    return @symbol = :X   if char == 'x' || char == :x || char == 'X' || char == :X
    return @symbol = :O   if char == 'o' || char == :o || char == 'O' || char == :O
    return @symbol = :' ' if char == ' ' || char == :' '
    raise "unknown piece"
  end

  def to_s
    @symbol.to_s
  end

#   def other
#     @symbol == :X ? :O : :X
#   end

  def ==(a)
    case a
    when Piece
      @symbol == a.symbol
    when Symbol
      @symbol == a
    else
      @symbol == a.to_sym
    end
  end
end

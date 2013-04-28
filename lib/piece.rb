class Piece
  attr_reader :symbol

  def initialize char
    @symbol = case char
              when 'x', :x, 'X', :X
                :X
              when 'o', :o, 'O', :O
                :O
              when ' ', :' '
                :' '
              else
                raise "unknown piece"
              end
    @lower_symbol = @symbol.to_s.downcase.to_sym
  end

  def to_s
    @symbol.to_s
  end

  def ==(a)
    case a
    when Piece
      @symbol == a.symbol
    when Symbol
      @symbol == a || @lower_symbol == a
    else
      @symbol == a.to_sym || @lower_symbol == a.to_sym
    end
  end
end

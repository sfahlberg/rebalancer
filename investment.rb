class Investment
  attr_accessor :name, :symbol, :shares, :share_price, :total_value

  def initialize(name, symbol, shares, share_price, total_value)
    @name = name
    @symbol = symbol
    @shares = shares
    @share_price = share_price
    @total_value = total_value
  end

  def fix_data
    @shares = shares.to_f
    @total_value = @total_value.to_f

    calculated_total_value = (@total_value / @shares).to_f

    if @share_price.nil?  || @share_price.to_i != calculated_total_value.to_i
      @share_price = calculated_total_value
    else
      @share_price = @share_price.to_f
    end
  end
end

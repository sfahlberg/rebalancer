require 'byebug'
class Investment
  attr_accessor :name, :symbol, :shares, :share_price, :total_value, :account_number, :current_percentage, :desired_percentage, :desired_value

  def initialize(name, symbol, shares, share_price, total_value, account_number)
    @name = name
    @symbol = symbol
    @shares = shares
    @share_price = share_price
    @total_value = total_value
    @desired_value = 0
    @current_percentage = 0
    @desired_percentage = 0
    @account_number = account_number
  end

  def symbolize_mma
    if @symbol.nil? && @name == "Vanguard Prime Money Market Fund"
      @symbol = "MMA"
    end
  end
  
  def calculate_share_price
    calculated_total_value = (@total_value / @shares).to_f
    if @share_price.nil?  || @share_price.to_i != calculated_total_value.to_i
      @share_price = calculated_total_value
    else
      @share_price = @share_price.to_f
    end
  end

  # def fix_data
  #   @shares = shares.to_f
  #   @total_value = @total_value.to_f
  #
  #
  # end
  
  # def calculate_desired_percentage
  #   portfolio_name = self.portfolio.name
  #   desired_portfolios = Parser.desired_portfolios
  #   if desired_portfolios[portfolio_name] && desired_portfolios[portfolio_name][@symbol]
  #     @desired_percentage = desired_portfolios[portfolio_name][@symbol]
  #   end
  # end

  def calculate_current_percentage
    @current_percentage = @total_value / @portfolio.portfolio_total_value * 100
  end

  def calculate_desired_value
    @desired_value = @portfolio.portfolio_total_value * @desired_percentage / 100
  end
end

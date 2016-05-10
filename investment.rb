require 'byebug'
class Investment
  attr_accessor :name, :symbol, :shares, :share_price, :total_value, :account_number, :current_percentage, :desired_percentage, :desired_value, :portfolio, :change_shares

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
    @portfolio = nil
    @change_shares = 0
  end

  def determine_change_in_shares(options)
    change_shares = (@desired_value - @total_value) / @share_price
    if (options[:buy] && change_shares > 0 ) || (options[:sell] && change_shares < 0)
      @change_shares = change_shares.round(2)
    end
  end

  def complete_data
    calculate_share_price
    calculate_current_percentage
    calculate_desired_value
  end

  # private

  def symbolize_mma
    if @symbol.nil? && @name == "Vanguard Prime Money Market Fund"
      @symbol = "VMMXX"
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
  
  def calculate_current_percentage
    @current_percentage = (@total_value / @portfolio.portfolio_total_value.to_f * 100).round(2)
  end

  def calculate_desired_value
    @desired_value = @portfolio.portfolio_total_value * @desired_percentage / 100
  end
end

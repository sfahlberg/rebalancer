require_relative 'investment'

class Portfolio
  attr_reader :portfolio_total_value, :name, :investments, :account_numbers
  def initialize(name, account_numbers, investments)
    @name = name
    @account_numbers = account_numbers
    @investments = investments
    @portfolio_total_value = 0
    @diff_for_action = 5
    @buy = false
    @sell = false
  end

  def calculate_portfolio_total_value
    @investments.each do |investment|
      @portfolio_total_value += investment.total_value
    end
  end

  def determine_buy_or_sell
    @investments.each do |inv|
      diff = inv.current_percentage - inv.desired_percentage

      if diff > diff_for_action
        @sell = true
      end

      if !@sell && diff < -diff_for_action
        @buy
      end
    end
  end
end

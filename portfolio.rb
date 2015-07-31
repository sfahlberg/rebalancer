require_relative 'investment'

class Portfolio
  attr_reader :portfolio_total_value, :name, :investments
  def initialize(name, account_numbers)
    @name = name
    @account_numbers = account_numbers
    @investments = []
    @portfolio_total_value = 0
    @diff_for_action = 5
    @buy = false
    @sell = false
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

require_relative 'investment'

class Portfolio
  attr_reader :portfolio_total_value, :name, :investments
  def initialize(name, account_numbers)
    @name = name
    @account_numbers = account_numbers
    @investments = []
    @portfolio_total_value = 0
    get_investment_for_this_portfolio
  end

  def get_investment_for_this_portfolio
    investments = []
    @account_numbers.each_key do |account_number|
      investments << @@accounts[account_number]
    end

    investments.flatten!

    investments.each do |investment|
      name = investment["Investment Name"] || investment["Fund Name"]
      symbol = investment["Symbol"]
      shares = investment["Shares"]
      share_price = investment["Share Price"]
      total_value = investment["Total Value"]
      new_investment = Investment.new(name, symbol, shares, share_price, total_value)
      new_investment.portfolio = self
      new_investment.fix_data

      @portfolio_total_value += total_value.to_f
      @investments << new_investment
    end
  end
end

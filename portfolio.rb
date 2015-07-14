require_relative 'investment'

class Portfolio
  def initialize(name, account_numbers)
    @name = name
    @account_numbers = account_numbers
    @investments = []
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
      new_investment.fix_data
      @investments << new_investment
    end
  end
end

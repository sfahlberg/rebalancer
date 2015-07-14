class Vanguard
  require 'csv'
  require_relative 'helpers'
  require_relative 'portfolio'
  attr_reader :portfolios

  def initialize
    Portfolio.get_investments
    @portfolios = get_portfolios
  end

  def get_portfolios 
    portfolios = []
    CSV.foreach('user_data/portfolio_names.txt', headers: true) do |line|
      name = line['Portfolio Name']
      accounts = {}

      (1...line.length).each do |i| 
        account_num = line["Account Number #{i}"]
        accounts[account_num] = true
      end

      portfolios << Portfolio.new(name, accounts)
    end
    portfolios
  end
end

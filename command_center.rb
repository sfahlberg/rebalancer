require_relative 'login_and_download'
require_relative 'vanguard_csv'
require_relative 'user_csv'
require_relative 'vanguard'
require 'rubygems'
require 'byebug'

FetchCSV.call!
vanguard_csv = VanguardCSV.new('data/','ofxdownload.csv')
vanguard_csv.get_accounts
investments = vanguard_csv.get_investments

user_csv = UserCSV.new('user_data/')
portfolios = user_csv.get_portfolios(investments)
vanguard =  Vanguard.new(portfolios)

vanguard.portfolios.each do |portfolio|
  if portfolio.name == 'traditional' || portfolio.name == 'after-tax'
    portfolio.calculate_portfolio_total_value
    portfolio.investments.each do |investment|
      investment.complete_data
      # p "#{investment.symbol} : #{investment.total_value} : #{investment.desired_value}"
    end

    portfolio.calculate_portfolio_total_value
    portfolio.determine_buy_or_sell
    p "sell" if  portfolio.sell
    p "buy" if portfolio.buy

    portfolio.amount_to_buy_or_sell
    portfolio.investments.each do |inv|
      p "#{inv.symbol} : #{inv.change_shares}"
    end
  end
end

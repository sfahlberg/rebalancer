# require_relative 'login_and_download'
require_relative 'vanguard_csv'
require_relative 'user_csv'
require_relative 'vanguard'
require 'rubygems'
require 'byebug'

vanguard_csv = VanguardCSV.new('data/','ofxdownload.csv')
vanguard_csv.get_accounts
investments = vanguard_csv.get_investments

user_csv = UserCSV.new('user_data/')
portfolios = user_csv.get_portfolios(investments)
vanguard =  Vanguard.new(portfolios)

vanguard.portfolios.each do |portfolio|
  # if portfolio.name == 'traditional'
    portfolio.investments.each do |investment|
      # investment.calculate_desired_percentage
      p "#{investment.symbol} : #{investment.current_percentage} : #{investment.desired_percentage}"
    end
  # end
end

# my_vanguard_account.portfolios.each do |portfolio|
#   p "PORTFOLIO: #{portfolio.name} : #{portfolio.portfolio_total_value}"
#   portfolio.investments.each do |investment|
#     investment.calculate_desired_value
#     p "#{investment.symbol} : #{investment.total_value} : #{investment.desired_value}"
#   end
# end

# require_relative 'login_and_download'
require_relative 'vanguard_data'
# require_relative 'algorithm'
# require_relative 'vanguard'
require 'rubygems'
require 'byebug'

vdata = VanguardData.new('data/ofxdownload.csv')
p Dir.pwd
# p vdata.get_investments
# my_vanguard_account = Vanguard.new
#
# my_vanguard_account.portfolios.each do |portfolio|
#   if portfolio.name == 'traditional'
#     portfolio.investments.each do |investment|
#       investment.calculate_desired_percentage
#       p "#{investment.symbol} : #{investment.current_percentage} : #{investment.desired_percentage}"
#     end
#   end
# end

# my_vanguard_account.portfolios.each do |portfolio|
#   p "PORTFOLIO: #{portfolio.name} : #{portfolio.portfolio_total_value}"
#   portfolio.investments.each do |investment|
#     investment.calculate_desired_value
#     p "#{investment.symbol} : #{investment.total_value} : #{investment.desired_value}"
#   end
# end

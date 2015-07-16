# require_relative 'login_and_download'
require_relative 'parser'
require_relative 'algorithm'
require_relative 'vanguard'
require 'rubygems'
require 'byebug'
include Parser

my_vanguard_account = Vanguard.new

my_vanguard_account.portfolios.each do |portfolio|
  if portfolio.name == 'traditional'
    portfolio.investments.each do |investment|
      investment.calculate_desired_value
      p "#{investment.symbol} : #{investment.total_value} : #{investment.desired_value}"
    end
  end
end

# my_vanguard_account.portfolios.each do |portfolio|
#   p "PORTFOLIO: #{portfolio.name} : #{portfolio.portfolio_total_value}"
#   portfolio.investments.each do |investment|
#     investment.calculate_desired_value
#     p "#{investment.symbol} : #{investment.total_value} : #{investment.desired_value}"
#   end
# end

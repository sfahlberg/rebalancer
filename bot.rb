require_relative 'fetch_vanguard_csv'
require_relative 'vanguard_csv'
require_relative 'user_data'
require_relative 'vanguard'
require 'rubygems'
require 'byebug'

class Bot
  def self.run(arguments)
    user_data = UserData.new()
    if arguments[0] == "fetch_new_csv" && arguments[1] == "remain_open"
      FetchVanguardCSV.call!(user_data, false)
    elsif arguments[0] == "fetch_new_csv"
      FetchVanguardCSV.call!(user_data)
    end
    csv_investments = get_investments_from_vanguard_csv
    vanguard = compare_vanguard_data_with_desired_portfolio_data(csv_investments, user_data)
    display_data_in_terminal(vanguard)
  end

  def self.get_investments_from_vanguard_csv
    vanguard_csv = VanguardCSV.new()
    vanguard_csv.get_accounts
    vanguard_csv.get_investments
  end

  def self.compare_vanguard_data_with_desired_portfolio_data(csv_investments, user_data)
    portfolios = user_data.create_portfolios(csv_investments)
    Vanguard.new(portfolios)
  end

  def self.display_data_in_terminal(vanguard)
    vanguard.portfolios.each do |portfolio|
        if portfolio.sell
          action = 'sell'
        elsif portfolio.buy
          action = 'buy'
        else
          action = 'hold'
        end

        puts action + " " + portfolio.name + " " + 'portfolio'
        puts

        portfolio.amount_to_buy_or_sell

        portfolio.investments.each do |inv|
          puts "#{inv.symbol} | current: #{inv.current_percentage}% | desired: #{inv.desired_percentage}%"
          unless action == "hold"
            puts action + " #{inv.change_shares} share"
          end
          puts
        end
    end
  end
end

Bot.run(ARGV)

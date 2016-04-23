require_relative 'fetch_vanguard_csv'
require_relative 'vanguard_csv'
require_relative 'user_csv'
require_relative 'vanguard'
require 'rubygems'
require 'byebug'

class VanguardBot

  def self.run
    FetchVanguardCSV.call!
    investments = get_investments_from_vanguard_csv
    vanguard = compare_vanguard_data_with_desired_portfolio_data(investments)
    display_data_in_terminal(vanguard)
  end

  def self.get_investments_from_vanguard_csv
    vanguard_csv = VanguardCSV.new('data/','ofxdownload.csv')
    vanguard_csv.get_accounts
    vanguard_csv.get_investments
  end


  def self.compare_vanguard_data_with_desired_portfolio_data(investments)
    user_csv = UserCSV.new('user_data/')
    portfolios = user_csv.get_portfolios(investments)
    Vanguard.new(portfolios)
  end

  def self.display_data_in_terminal(vanguard)
    vanguard.portfolios.each do |portfolio|
      if portfolio.name == 'traditional' || portfolio.name == 'after-tax'

        portfolio.calculate_portfolio_total_value

        portfolio.investments.each do |investment|
          investment.complete_data
          # p "#{investment.symbol} : #{investment.total_value} : #{investment.desired_value}"
        end

        portfolio.calculate_portfolio_total_value

        portfolio.determine_buy_or_sell

        if portfolio.sell
          action = 'sell'
        elsif portfolio.buy
          action = 'buy'
        else
          action = 'hold'
        end

        p action + " " + portfolio.name + " " + 'portfolio'
        p 'the following is the amount of shares'

        portfolio.amount_to_buy_or_sell

        portfolio.investments.each do |inv|
          p "#{inv.symbol} : #{inv.change_shares}"
        end
      end
    end
  end
end

VanguardBot.run

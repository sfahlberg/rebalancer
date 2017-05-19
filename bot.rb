require_relative 'fetch_vanguard_csv'
require_relative 'vanguard_csv'
require_relative 'user_data'
require_relative 'vanguard'
require 'rubygems'
require 'bundler/setup'
require 'gmail'
require 'pry'

class Bot
  def self.run(arguments)
    user_data = UserData.new
    if arguments[0] == 'fetch_new_csv' && arguments[1] == 'remain_open'
      FetchVanguardCSV.call!(user_data, false)
    elsif arguments[0] == 'fetch_new_csv'
      FetchVanguardCSV.call!(user_data)
    end
    csv_investments = investments_from_vanguard_csv
    vanguard = compare_vanguard_data_with_desired_portfolio_data(csv_investments, user_data)
    final_data = final_data(vanguard)
    send_email(user_data, final_data)
  end

  def self.investments_from_vanguard_csv
    vanguard_csv = VanguardCSV.new
    vanguard_csv.get_accounts
    vanguard_csv.get_investments
  end

  def self.compare_vanguard_data_with_desired_portfolio_data(csv_investments, user_data)
    portfolios = user_data.create_portfolios(csv_investments)
    Vanguard.new(portfolios)
  end

  def self.send_email(user_data, final_data)
    gmail = Gmail.new(user_data.email, user_data.email_password)
    gmail.deliver do
      to 'test@gmail.com'
      subject 'Vanguard Report'
      text_part do
        body final_data
      end
    end
    gmail.logout
  end

  def self.final_data(vanguard)
    text = ''
    vanguard.portfolios.each do |portfolio|
      action = 'hold'
      if portfolio.sell
        action = 'sell'
      elsif portfolio.buy
        action = 'buy'
      end

      text += "#{action} #{portfolio.name} portfolio \n \n"

      portfolio.amount_to_buy_or_sell

      portfolio.investments.each do |inv|
        text += "#{inv.symbol} |"
        text += " current: #{inv.current_percentage}% |"
        text += " desired: #{inv.desired_percentage}% \n"
        text += "action #{inv.change_shares} share \n" unless action == 'hold'
      end
      text += "\n"
    end
    text
  end
end

Bot.run(ARGV)

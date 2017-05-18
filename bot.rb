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
    user_data = UserData.new()
    if arguments[0] == "fetch_new_csv" && arguments[1] == "remain_open"
      FetchVanguardCSV.call!(user_data, false)
    elsif arguments[0] == "fetch_new_csv"
      FetchVanguardCSV.call!(user_data)
    end
    csv_investments = get_investments_from_vanguard_csv
    vanguard = compare_vanguard_data_with_desired_portfolio_data(csv_investments, user_data)
    display_data_in_terminal(vanguard)
    send_email(user_data)
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

  def self.send_email(user_data)
    gmail = Gmail.new(user_data.email, user_data.email_password)
    gmail.deliver do
      to 'test@gmail.com'
      subject 'test'
      text_part do
        body 'Text of plaintext message.'
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body '<p>Text of <em>html</em> message.</p>'
      end
    end
    gmail.logout
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

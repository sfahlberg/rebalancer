require 'json'
require_relative 'portfolio'

class UserData
  attr_reader :path, :desired_portfolios

  def initialize(path = 'user_data/')
    @path = path 
    fetch_user_data_from_json
  end

  def fetch_user_data_from_json
    credentials_file = File.read(@path + 'user_data.json')
    file = JSON.parse(credentials_file)
    set_credentials(file['credentials'])
    set_portfolios(file['portfolios'])
  end

  def set_credentials(credentials)
    @username = credentials['username']
    @password = credentials['password']
    @security_questions = credentials['security_questions']
  end

  def set_portfolios(portfolio_data)
    @portfolios = portfolio_data
  end
  
  def create_portfolios(investments) 
    portfolios = []

    @portfolios.each do |portfolio|

      account_numbers = {}
      portfolio['account-numbers'].each do |acct|
        account_numbers[acct] = true
      end

      investments_for_accounts = get_investments_for_accounts(investments, portfolio)

      current_portfolio = Portfolio.new(portfolio['name'], account_numbers.keys, investments_for_accounts)

      set_portfolio_of_investment_equal_to_current_portfolio(current_portfolio)

      portfolios << current_portfolio
    end
    portfolios
  end

  def set_portfolio_of_investment_equal_to_current_portfolio(portfolio)
    portfolio.investments.each do |inv|
      inv.portfolio = portfolio
    end
  end

  def get_investments_for_accounts(investments, portfolio_data)
    investments_for_accounts = []
    investments.each do |investment|
      idx = portfolio_data['account-numbers'].index(investment.account_number)
      if idx
        # set desired percent from user_data
        unless investment.name == "Vanguard Prime Money Market Fund"
          desired_percent = portfolio_data['breakdown'][investment.symbol]
          investment.desired_percentage = desired_percent
        end
        investments_for_accounts << investment
      end
    end
    investments_for_accounts
  end
end

require 'json'
require_relative 'portfolio'

class UserData
  attr_reader :path, :desired_portfolios, :username, :password, :security_questions

  def initialize(path = 'user_data/')
    @path = path
    fetch_user_data_from_json
  end

  def create_portfolios(investments)
    portfolios = []

    @portfolios.each do |portfolio|
      investments_for_portfolio = get_investments_for_portfolio(investments, portfolio)
      current_portfolio = Portfolio.new(portfolio['name'], portfolio['account-numbers'], investments_for_portfolio)
      calculate_more_data(current_portfolio)
      portfolios << current_portfolio
    end

    portfolios
  end

  private

  def calculate_total_portfolio_value(investments)
      total_portfolio_value = 0
      investments.each do |inv|
        total_portfolio_value += inv.total_value
      end
      total_portfolio_value
  end

  def calculate_more_data(portfolio)
    portfolio.investments.each do |inv|
      inv.portfolio = portfolio
      inv.complete_data
    end
    portfolio.determine_buy_or_sell
  end

  def get_investments_for_portfolio(investments, portfolio_data)
    investments_for_portfolio = []
    investments.each do |investment|
      idx = portfolio_data['account-numbers'].index(investment.account_number)
      if idx
        # set desired percent from user_data
        desired_percent = portfolio_data['breakdown'][investment.symbol]
        investment.desired_percentage = desired_percent || 0
        investments_for_portfolio << investment
      end
    end
    investments_for_portfolio
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
end

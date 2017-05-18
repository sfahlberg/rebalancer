require 'json'
require_relative 'portfolio'

class UserData
  attr_reader :path, :desired_portfolios, :username, :password, :security_questions, :email, :email_password

  def initialize(path = 'user_data/')
    @path = path
    fetch_user_data_from_json
  end

  def create_portfolios(csv_investments)
    portfolios = []

    @portfolios.each do |portfolio|
      investments_for_portfolio = get_investments_for_portfolio(csv_investments, portfolio)
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

  def get_investments_for_portfolio(csv_investments, portfolio_data)
    investments_for_portfolio = []
    desired_breakdown = portfolio_data['breakdown']
    csv_investments.each do |csv_investment|
      idx = portfolio_data['account-numbers'].index(csv_investment.account_number)
      if idx
        # set desired percent from user_data
        desired_percent = desired_breakdown.delete(csv_investment.symbol)
        # if there is no percent desired by user, a zero is put there, so investment will be sold
        csv_investment.desired_percentage = desired_percent || 0
        investments_for_portfolio << csv_investment
      end
    end
    # TODO: pull in outside data for stock prices to get this working
    # desired_breakdown.each do |leftover_investment_symbol_not_yet_owned, percent|
    #   investments_for_portfolio << Investment.new(
    #     leftover_investment_symbol_not_yet_owned,
    #     leftover_investment_symbol_not_yet_owned,
    #     0,
    #     investment["Share Price"],
    #     0
    #   )
    # end
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
    @email = credentials['email']
    @email_password = credentials['email-password']
  end

  def set_portfolios(portfolio_data)
    @portfolios = portfolio_data
  end
end

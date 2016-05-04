require 'json'
require_relative 'portfolio'

class UserData
  attr_reader :path, :desired_portfolios

  def initialize(path = 'user_data/')
    @path = path 
  end

  def get_portfolios(investments)
    portfolios = self.create_portfolios(investments)
    desired_portfolios = self.get_desired_portfolios
    portfolios.each do |portfolio|
      current_desired_portfolio = desired_portfolios[portfolio.name]

      if current_desired_portfolio
        portfolio.investments.each do |investment|
          desired_percentage = current_desired_portfolio[investment.symbol]
          investment.desired_percentage = desired_percentage || 0
        end
      end
    end
    portfolios
  end

  def get_desired_portfolios
    credentials_file = File.read(@path + 'credentials.json')
    file = JSON.parse(credentials_file)
    portfolios = Hash.new()
    file['portfolios'].each do |portfolio|
      name = portfolio['name']
      portfolios[name] = portfolio['breakdown']
    end
    portfolios
  end

  
  def create_portfolios(investments) 
    portfolios = []

    credentials_file = File.read(@path + 'credentials.json')
    file = JSON.parse(credentials_file)
    file['portfolios'].each do |portfolio|
      name = portfolio['name']

      # grab the different account numbers in CSV
      accounts = {}
      portfolio['account-numbers'].each do |acct|
        accounts[acct] = true
      end

      # only use portfolios accounts
      current_investments = []
      investments.each do |investment|
        if accounts[investment.account_number]
          current_investments << investment
        end
      end

      current_portfolio = Portfolio.new(name, accounts, current_investments)

      #set portfolio of investment equal to current_portfolio
      current_portfolio.investments.each do |inv|
        inv.portfolio = current_portfolio
      end

      portfolios << current_portfolio
    end
    portfolios
  end
end

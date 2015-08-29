require 'csv'
require_relative 'portfolio'
class UserCSV
  attr_reader :path, :desired_portfolios

  def initialize(path)
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
    portfolios = {}
    CSV.foreach(@path + 'desired_portfolio.txt', headers: true) do |line|
      current_portfolio = line["Portfolio"]
      current_investment = line["Symbol"]
      
      unless portfolios[current_portfolio]
        portfolios[current_portfolio] = {}
      end

      unless portfolios[current_portfolio][current_investment]
        portfolios[current_portfolio][current_investment] = {}
      end
     
      portfolios[current_portfolio][current_investment] = line["Percent"].to_f
    end 
    portfolios
  end

  def create_portfolios(investments) 
    portfolios = []
    CSV.foreach(@path + 'portfolio_names.txt', headers: true) do |line|
      name = line['Portfolio Name']
      accounts = {}

      # grab the different account numbers in CSV
      (1...line.length).each do |i| 
        account_num = line["Account Number #{i}"]
        accounts[account_num] = true
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

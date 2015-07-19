require 'csv'
class UserData
  def initialize(file)
    @path_to_csv
  end
  
  def get_desired_portfolios
    portfolios = {}
    CSV.foreach('user_data/desired_portfolio.txt', headers: true) do |line|
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

  def desired_portfolios
    @@desired_portfolios ||= get_desired_portfolios
  end

  def get_portfolios 
    portfolios = []
    CSV.foreach('user_data/portfolio_names.txt', headers: true) do |line|
      name = line['Portfolio Name']
      accounts = {}

      (1...line.length).each do |i| 
        account_num = line["Account Number #{i}"]
        accounts[account_num] = true
      end

      portfolios << Portfolio.new(name, accounts)
    end
    portfolios
  end
end

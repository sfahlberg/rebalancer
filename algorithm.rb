require 'byebug'
def crunch_numbers(accounts)
  current_portfolio = accounts['traditional']
  desired_portfolio = get_desired_portfolio

  changes = get_changes(current_portfolio, desired_portfolio)
  p changes
end

def get_desired_portfolio
  investments = {}
  CSV.foreach('user_data/desired_portfolio.txt', headers: true) do |line|
    # investments[line]
    investments[line["Symbol"]] = line["Percent"]
  end 
  investments 
end

def get_changes(current, desired)
  total_dollars = 0
  current.each_value do |data|
    total_dollars += data["Total Value"]
  end

  #TODO check if the investment already exists
  #TODO if now,  integrate with API to get current stock prices

  current.each do |symbol, data|
    desired_percent = desired[symbol]
    if desired_percent
      # investment desired in portfolio
      target = desired_percent.to_i * total_dollars / 100  
    else
      #is not currently desired in portfolio
      target = 0
    end
    data["Target Value"] = target

    diff = target - data['Total Value']
    
    shares_to_move = diff / data['Share Price']

    if symbol == "MMA"
      puts diff.to_s
      puts data['Share Price'].to_s
    end

    if shares_to_move > 0
      data["Shares To Buy"] = shares_to_move
    else
      data["Shares To Sell"] = shares_to_move
    end
  end
end

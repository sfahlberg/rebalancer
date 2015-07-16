require 'csv'
module Parser
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

  def get_investments
    @@accounts = get_accounts
  end

  def build_new_csvs(filename, blob)
    CSV.open("data/tmp/#{filename}.csv", 'w') do |csv_object|
      blob.each do |row|
        next if row.empty?
        csv_object << row
      end
    end
  end

  FUNDS = {}

  def run_blob(filename, identifier)
    path = "data/tmp/#{filename}.csv"
    CSV.foreach(path, headers: true) do |line|
      account = line[identifier]
      next if account == nil
      current_account = {}

      line.headers.each_with_index do |header, i|
        next if header == nil
        unless identifier == header
          current_account[header] = line[i]
        end
      end

      FUNDS[account] ||= []
      FUNDS[account] << current_account
    end

    File.delete(path)
  end


  BLOBS = []
  def check_if_trades(current_blob)
    unless current_blob[0][1] == "Trade Date"
      BLOBS << current_blob
    end
  end

  def parse_downloaded_csv
    current_blob = []
    CSV.foreach('data/ofxdownload.csv') do |line|
      if line.length > 0 && line[0][0].is_letter? && current_blob.length > 0
        check_if_trades(current_blob)
        current_blob = []
      end
      current_blob << line
    end
    check_if_trades(current_blob)
  end

  def get_accounts
    parse_downloaded_csv

    i = 0
    BLOBS.each do |blob|
      i += 1
      build_new_csvs(i, blob) 
    end

    names = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]

    (1..i).each do |idx|
      run_blob(idx, names[idx - 1])
    end
    FUNDS
  end
end

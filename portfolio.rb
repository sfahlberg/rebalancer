require_relative 'investment'

class Portfolio
  def initialize(name, account_numbers)
    @name = name
    @account_numbers = account_numbers
    @investments = []
    get_investment_for_this_portfolio
  end

  require 'csv'

  def get_investment_for_this_portfolio
    investments = []
    @account_numbers.each_key do |account_number|
      investments << @@accounts[account_number]
    end

    investments.flatten!

    investments.each do |investment|
      name = investment["Investment Name"] || investment["Fund Name"]
      symbol = investment["Symbol"]
      shares = investment["Shares"]
      share_price = investment["Share Price"]
      total_value = investment["Total Value"]
      new_investment = Investment.new(name, symbol, shares, share_price, total_value)
      new_investment.fix_data
      @investments << new_investment
    end
  end

  def self.get_investments
    @@accounts = self.get_accounts
  end

  def self.build_new_csvs(filename, blob)
    CSV.open("data/tmp/#{filename}.csv", 'w') do |csv_object|
      blob.each do |row|
        next if row.empty?
        csv_object << row
      end
    end
  end

  FUNDS = {}

  def self.run_blob(filename, identifier)
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
  def self.check_if_trades(current_blob)
    unless current_blob[0][1] == "Trade Date"
      BLOBS << current_blob
    end
  end

  def self.parse_downloaded_csv
    current_blob = []
    CSV.foreach('data/ofxdownload.csv') do |line|
      if line.length > 0 && line[0][0].is_letter? && current_blob.length > 0
        self.check_if_trades(current_blob)
        current_blob = []
      end
      current_blob << line
    end
    self.check_if_trades(current_blob)
  end

  def self.get_accounts
    self.parse_downloaded_csv

    i = 0
    BLOBS.each do |blob|
      i += 1
      self.build_new_csvs(i, blob) 
    end

    names = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]

    (1..i).each do |idx|
      self.run_blob(idx, names[idx - 1])
    end
    FUNDS
  end
end

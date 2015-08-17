require 'csv'
require_relative 'helpers'
require_relative 'investment'

class VanguardCSV
  attr_reader :path_to_csv, :sections, :investments
  attr_accessor :funds

  def initialize(path, filename)
    @path_to_data = path
    @filename = filename
    @names = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]
    @sections = []
    @funds = {}
    @investments = []
  end

  def get_accounts
    parse_downloaded_csv
    remove_trade_data

    build_helper_csvs 
    parse_helper_csvs
  end

  def get_investments
    investments = []
    @funds.each_key do |account_number|
      current_investments = @funds[account_number]

      current_investments.each do |investment|
        portfolio = account_number
        name = investment["Investment Name"] || investment["Fund Name"]
        symbol = investment["Symbol"]
        shares = investment["Shares"]
        share_price = investment["Share Price"]
        total_value = investment["Total Value"]
        new_investment = Investment.new(name, symbol, shares, share_price, total_value, portfolio)
        @investments << new_investment
      end
    end

    # investments.flatten!
    # investments.each do |investment|
    #   name = investment["Investment Name"] || investment["Fund Name"]
    #   symbol = investment["Symbol"]
    #   shares = investment["Shares"]
    #   portfolio = investment["portfolio"]
    #   share_price = investment["Share Price"]
    #   total_value = investment["Total Value"]
    #   new_investment = Investment.new(name, symbol, shares, share_price, total_value, portfolio)
    #   @investments << new_investment
    # end
    @investments
  end
  
  private
  def build_helper_csvs(dir = 'tmp/')
    @sections.each_with_index do |section, idx|
      path = @path_to_data + dir + idx.to_s + ".csv"
      CSV.open(path, 'w') do |csv_object|
        section.each do |row|
          next if row.empty?
          csv_object << row
        end
      end
    end
  end

  def parse_helper_csvs(dir = 'tmp/')
    @sections.each_index do |idx|
      path = @path_to_data + dir + idx.to_s + ".csv"
      identifier = @names[idx]

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

        @funds[account] ||= []
        @funds[account] << current_account
      end
    end
  end

  def parse_downloaded_csv
    current_section = []
    
    CSV.foreach(@path_to_data + @filename) do |line|

      if line.length > 0 && line[0][0].is_letter? && !current_section.empty?
        @sections << current_section
        current_section = []
      end
      
      current_section << line
    end

    @sections << current_section
  end

  def remove_trade_data
    cleaned_sections = []
    @sections.each do |section|
      if section[0][1] != "Trade Date"
        cleaned_sections << section
      end
    end
    @sections = cleaned_sections
  end
end

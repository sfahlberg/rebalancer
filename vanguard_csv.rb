require 'csv'
require_relative 'helpers'
require_relative 'investment'

class VanguardCSV
  attr_reader :path_to_csv, :sections, :investments
  attr_accessor :funds

  def initialize(path = 'data/', filename = 'ofxdownload.csv')
    @path_to_data = path
    @filename = filename
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
    @funds.each_key do |account_number|
      current_investments = @funds[account_number]

      current_investments.each do |investment|
        @investments << Investment.new(
          investment['Investment Name'] || investment['Fund Name'],
          investment['Symbol'],
          investment['Shares'],
          investment['Share Price'],
          investment['Total Value'],
          account_number
        )
      end
    end
    @investments
  end

  private
  def build_helper_csvs(dir = 'tmp/')
    @sections.each_with_index do |section, idx|
      path = @path_to_data + dir + idx.to_s + '.csv'
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
      path = @path_to_data + dir + idx.to_s + '.csv'

      CSV.foreach(path, headers: true) do |line|
        account = line['Account Number']
        next if account.nil?
        current_account = {}

        line.headers.each_with_index do |header, i|
          next if header.nil?
          current_account[header] = line[i] unless 'Account Number' == header
        end

        @funds[account] ||= []
        @funds[account] << current_account
      end
    end
  end

  def parse_downloaded_csv
    current_section = []

    CSV.foreach(@path_to_data + @filename) do |line|
      if !line.empty? && line[0][0].is_letter? && !current_section.empty?
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
      cleaned_sections << section if section[0][1] != 'Trade Date'
    end
    @sections = cleaned_sections
  end
end

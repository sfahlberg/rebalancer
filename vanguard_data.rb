require 'csv'
require_relative 'helpers'

class VanguardData
  attr_reader :path_to_csv, :sections
  attr_accessor :funds

  def initialize(path)
    @path_to_csv = path
    @funds = {}
    @names = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]
    @sections = []
  end

  def build_helper_csv(filename, section)
    CSV.open("data/tmp/#{filename}.csv", 'w') do |csv_object|
      section.each do |row|
        next if row.empty?
        csv_object << row
      end
    end
  end

  def parse_helper_csv(filename, identifier)
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

      @funds[account] ||= []
      @funds[account] << current_account
    end

    File.delete(path)
  end

  def parse_downloaded_csv
    current_section = []
    
    CSV.foreach(@path_to_csv) do |line|

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

  def get_accounts
    parse_downloaded_csv
    remove_trade_data

    @sections.each_with_index do |section, idx|
      build_helper_csv(idx, section) 
      parse_helper_csv(idx, @names[idx])
    end

    @funds
  end
end

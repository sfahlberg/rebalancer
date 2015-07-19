require 'csv'
require_relative 'helpers'
class VanguardData
  attr_reader :path_to_csv
  attr_accessor :funds, :accounts

  def initialize(path)
    @path_to_csv = path
    @funds = {}
    @accounts
  end


  def get_investments
    @accounts = get_accounts
  end

  def build_new_csvs(filename, blob)
    CSV.open("data/tmp/#{filename}.csv", 'w') do |csv_object|
      blob.each do |row|
        next if row.empty?
        csv_object << row
      end
    end
  end

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

      @funds[account] ||= []
      @funds[account] << current_account
    end

    File.delete(path)
  end


  # TODO: make this an instance variable
  BLOBS = []
  def check_if_trades(current_blob)
    unless current_blob[0][1] == "Trade Date"
      BLOBS << current_blob
    end
  end

  def parse_downloaded_csv
    current_blob = []
    CSV.foreach(@path_to_csv) do |line|
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

    BLOBS.each_with_index do |blob, i|
      build_new_csvs(i, blob) 
    end

    names = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]

    (0..BLOBS.length).each do |idx|
      run_blob(idx, names[idx])
    end
    @funds
  end
end

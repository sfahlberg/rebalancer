require 'csv'
class VanguardData
  attr_reader :path_to_csv

  def initialize(path)
    @path_to_csv = path
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
    CSV.foreach('') do |line|
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
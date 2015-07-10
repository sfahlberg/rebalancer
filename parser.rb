require 'csv'
require 'byebug'

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

class String
  def is_letter?
    !self.match(/^[[:alpha:]]+$/).nil?
  end
end

BLOBS = []
def check_if_trades(current_blob)
  unless current_blob[0][1] == "Trade Date"
    BLOBS << current_blob
  end
end

def add_account_type
  lines = []
  File.readlines('user_data/account_names.txt').each do |line|
    line = line.gsub!("\n","")
    p line
    lines << line unless line.nil?
  end


  (0..lines.length - 2).step(2) do |i|

   # p lines[i]
    # p lines[i + 1]
    # byebug
    
    FUNDS[lines[i]].each do |investment| 
      investment["tax type"] = lines[i + 1]
    end
  end

  
  FUNDS
end

def get_accounts
  current_blob = []
  CSV.foreach('data/ofxdownload.csv') do |line|
    if line.length > 0 && line[0][0].is_letter? && current_blob.length > 0
      check_if_trades(current_blob)
      current_blob = []
    end
    current_blob << line
  end
  check_if_trades(current_blob)

  i = 0
  BLOBS.each do |blob|
    i += 1
    build_new_csvs(i, blob) 
  end

  names = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]
  (1..i).each do |idx|
    run_blob(idx, names[idx - 1])
  end

  add_account_type

  p FUNDS
end
# FUNDS = { 34 => [] }

get_accounts

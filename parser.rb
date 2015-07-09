require 'csv'

def build_new_csvs(filename, blob)
  CSV.open("data/tmp/#{filename}.csv", 'w') do |csv_object|
    blob.each do |row|
      next if row.empty?
      csv_object << row
    end
  end
end

def run_blob(blob, identifier)
  p blob
  exit
  funds = {}
  CSV.foreach('data/test.csv', headers: true) do |line|
    account = line[identifier]
    next if account == nil
    current_account = {}

    line.headers.each_with_index do |header, i|
      next if header == nil
      unless identifier == header
        current_account[header] = line[i]
      end
    end

    funds[account] = current_account
  end
  p funds
end

class String
  def is_letter?
    !self.match(/^[[:alpha:]]+$/).nil?
  end
end

current_blob = []
blobs = []
CSV.foreach('data/ofxdownload.csv') do |line|
  if line.length > 0 && line[0][0].is_letter? && current_blob.length > 0
    blobs << current_blob
    current_blob = []
  end
  current_blob << line
end
blobs << current_blob

i = 0
blobs.each do |blob|
  build_new_csvs(i, blob) 
  i += 1
end
# descriptor = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]

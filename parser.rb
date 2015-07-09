require 'csv'

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

# run_blob('Fund Account Number')
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

# descriptor = ["Fund Account Number", "Account Number", "Account Number", "Account Number"]

# blobs.each_with_index do |blob, i|
#   run_blob(blob, descriptor[i])
# end

# run_blob(blobs[0], descriptor[0])
my_blob = blobs[0]
CSV.open('data/tmp/1.csv', 'w') do |csv_object|
  my_blob.each do |row|
    csv_object << row
  end
end
# new_csv = CSV.open('data/tmp/1.csv')
# new_csv.each do |line|
#   line << my_blob.shift
#   puts
#   p my_blob
# end

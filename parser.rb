require 'csv'
identifier = 'Fund Account Number'
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

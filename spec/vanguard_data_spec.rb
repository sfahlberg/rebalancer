require_relative '../vanguard_data'

RSpec.describe VanguardData do
  context '#initialize' do
    it 'sets path' do
      current_data = VanguardData.new('spec/test_data/simple.csv')
      current_data.path_to_csv == 'spec/test_data/simple.csv'
    end
  end

  context '#parse_downloaded_csv' do
    it 'brings pulls data into @sections' do
      current_data = VanguardData.new('spec/test_data/simple.csv')
      current_data.parse_downloaded_csv
      output = [[["Fund Account Number", "Fund Name", "Price", "Shares", "Total Value", nil], [], ["0030-11111111111", "Vanguard Prime Money Market Fund", "1.00", "130.680", "130.68", nil], [], []], [["Account Number", "Trade Date", "Process Date", "Transaction Type", "Transaction Description", "Investment Name", "Share Price", "Shares", "Gross Amount", "Net Amount", nil], ["22222222222", "07/02/2015", "07/02/2015", "Buy", "NET SWEEP FROM BROKERAGE", "Prime Money Mkt Fund", "1.0", "59.44", "59.44", "59.44", nil], [], []], [["Account Number", "Investment Name", "Symbol", "Shares", "Share Price", "Total Value", nil], ["44444444", "VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "VXUS", "60.4", "49.63", "2997.65", nil]]]

      expect(current_data.sections).to eq(output)

    end
  end

  context '#remove_trade_data' do
    it 'gets rid of trade data' do
      current_data = VanguardData.new('spec/test_data/simple.csv')
      current_data.parse_downloaded_csv
      current_data.remove_trade_data

      output = [[["Fund Account Number", "Fund Name", "Price", "Shares", "Total Value", nil], [], ["0030-11111111111", "Vanguard Prime Money Market Fund", "1.00", "130.680", "130.68", nil], [], []], [["Account Number", "Investment Name", "Symbol", "Shares", "Share Price", "Total Value", nil], ["44444444", "VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "VXUS", "60.4", "49.63", "2997.65", nil]]]

      expect(current_data.sections).to eq(output)
    end
  end

  context '#get_acccounts' do
    it 'returns the accounts' do
      current_data = VanguardData.new('spec/test_data/original.csv')
      current_data.get_accounts

      p current_data.funds

      # expect(current_data.funds).to eq(output)
    end
  end
end

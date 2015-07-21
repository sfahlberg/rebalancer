require_relative '../vanguard_data'

RSpec.describe VanguardData do
  context '#initialize' do
    it 'sets path' do
      current_data = VanguardData.new('data/ofxdownload.csv')
      current_data.path_to_csv == 'data/ofxdownload.csv'
    end
  end

  context '#parse_downloaded_csv' do
    it 'brings pulls data into @sections' do
      current_data = VanguardData.new('spec/test_data/original.csv')
      current_data.parse_downloaded_csv

      output = [[["Fund Account Number", "Fund Name", "Price", "Shares", "Total Value", nil], [], ["0030-11111111111", "Vanguard Prime Money Market Fund", "1.00", "130.680", "130.68", nil], ["0030-22222222222", "Vanguard Prime Money Market Fund", "1.00", "26576.820", "26576.82", nil], ["0030-33333333333", "Vanguard Prime Money Market Fund", "1.00", "2872.030", "2872.03", nil], [], []], [["Account Number", "Trade Date", "Process Date", "Transaction Type", "Transaction Description", "Investment Name", "Share Price", "Shares", "Gross Amount", "Net Amount", nil], ["22222222222", "07/02/2015", "07/02/2015", "Buy", "NET SWEEP FROM BROKERAGE", "Prime Money Mkt Fund", "1.0", "59.44", "59.44", "59.44", nil], [], []], [["Account Number", "Investment Name", "Symbol", "Shares", "Share Price", "Total Value", nil], ["44444444", "VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "VXUS", "60.4", "49.63", "2997.65", nil], ["44444444", "VANGUARD TOTAL STOCK MARKET ETF", "VTI", "21.078", "107.30", "2261.67", nil], ["44444444", "VANGUARD S&P 500 INDEX ETF NEW", "VOO", "14.076", "189.58", "2668.53", nil], [], ["55555555", "VANGUARD VALUE ETF", "VTV", "98.848", "83.52", "8255.78", nil], ["55555555", "VANGUARD TOTAL STOCK MARKET ETF", "VTI", "366.581", "107.30", "39334.14", nil], ["55555555", "VANGUARD REIT INDEX ETF", "VNQ", "78", "76.59", "5974.02", nil], [], ["66666666", "AMAZON.COM INC", "AMZN", "3", "436.04", "1308.12", nil], ["66666666", "SPDR GOLD TRUST GOLD SHARES", "GLD", "16", "112.06", "1792.96", nil], ["66666666", "TESLA MOTORS INC", "TSLA", "5", "279.72", "1398.60", nil], [], [], []], [["Account Number", "Trade Date", "Settlement Date", "Transaction Type", "Transaction Description", "Investment Name", "Symbol", "Shares", "Share Price", "Principal Amount", "Commission Fees", "Net Amount", "Accrued Interest", "Account Type", nil], ["44444444", "07/02/2015", "07/02/2015", "Dividend", "VANGUARD TOTAL STOCK    MARKET ETF              070215          21.07800", "VANGUARD TOTAL STOCK MARKET ETF", "VTI", "0.0", "0.0", "9.86", "0.0", "9.86", "-0.0", "CASH", nil], ["44444444", "06/26/2015", "06/26/2015", "Sweep To", "VANGUARD PRIME MONEY    MARKET FUND", "CASH", nil, "0.0", "1.0", "-49.37", "0.0", "-49.37", "-0.0", "CASH", nil], ["55555555", "06/25/2015", "06/25/2015", "Sweep From", "VANGUARD PRIME MONEY    MARKET FUND", "CASH", nil, "0.0", "1.0", "40398.2", "0.0", "40398.2", "-0.0", "CASH", nil], ["66666666", "06/25/2015", "06/25/2015", "Sweep From", "VANGUARD PRIME MONEY    MARKET FUND", "CASH", nil, "0.0", "1.0", "4316.52", "0.0", "4316.52", "-0.0", "CASH", nil], [], []]]

      expect(current_data.sections).to eq(output)

    end
  end

  context '#remove_trade_data' do
    it 'gets rid of trade data' do
      current_data = VanguardData.new('spec/test_data/original.csv')
      current_data.parse_downloaded_csv
      current_data.remove_trade_data

      output = [[["Fund Account Number", "Fund Name", "Price", "Shares", "Total Value", nil], [], ["0030-11111111111", "Vanguard Prime Money Market Fund", "1.00", "130.680", "130.68", nil], ["0030-22222222222", "Vanguard Prime Money Market Fund", "1.00", "26576.820", "26576.82", nil], ["0030-33333333333", "Vanguard Prime Money Market Fund", "1.00", "2872.030", "2872.03", nil], [], []], [["Account Number", "Investment Name", "Symbol", "Shares", "Share Price", "Total Value", nil], ["44444444", "VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "VXUS", "60.4", "49.63", "2997.65", nil], ["44444444", "VANGUARD TOTAL STOCK MARKET ETF", "VTI", "21.078", "107.30", "2261.67", nil], ["44444444", "VANGUARD S&P 500 INDEX ETF NEW", "VOO", "14.076", "189.58", "2668.53", nil], [], ["55555555", "VANGUARD VALUE ETF", "VTV", "98.848", "83.52", "8255.78", nil], ["55555555", "VANGUARD TOTAL STOCK MARKET ETF", "VTI", "366.581", "107.30", "39334.14", nil], ["55555555", "VANGUARD REIT INDEX ETF", "VNQ", "78", "76.59", "5974.02", nil], [], ["66666666", "AMAZON.COM INC", "AMZN", "3", "436.04", "1308.12", nil], ["66666666", "SPDR GOLD TRUST GOLD SHARES", "GLD", "16", "112.06", "1792.96", nil], ["66666666", "TESLA MOTORS INC", "TSLA", "5", "279.72", "1398.60", nil], [], [], []]]

      expect(current_data.sections).to eq(output)
    end
  end

  context '#get_acccounts' do
    it 'returns the ccounts' do
      current_data = VanguardData.new('spec/test_data/original.csv')
      current_data.get_accounts

      output = {"0030-11111111111"=>[{"Fund Name"=>"Vanguard Prime Money Market Fund", "Price"=>"1.00", "Shares"=>"130.680", "Total Value"=>"130.68"}], "0030-22222222222"=>[{"Fund Name"=>"Vanguard Prime Money Market Fund", "Price"=>"1.00", "Shares"=>"26576.820", "Total Value"=>"26576.82"}], "0030-33333333333"=>[{"Fund Name"=>"Vanguard Prime Money Market Fund", "Price"=>"1.00", "Shares"=>"2872.030", "Total Value"=>"2872.03"}], "44444444"=>[{"Investment Name"=>"VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "Symbol"=>"VXUS", "Shares"=>"60.4", "Share Price"=>"49.63", "Total Value"=>"2997.65"}, {"Investment Name"=>"VANGUARD TOTAL STOCK MARKET ETF", "Symbol"=>"VTI", "Shares"=>"21.078", "Share Price"=>"107.30", "Total Value"=>"2261.67"}, {"Investment Name"=>"VANGUARD S&P 500 INDEX ETF NEW", "Symbol"=>"VOO", "Shares"=>"14.076", "Share Price"=>"189.58", "Total Value"=>"2668.53"}], "55555555"=>[{"Investment Name"=>"VANGUARD VALUE ETF", "Symbol"=>"VTV", "Shares"=>"98.848", "Share Price"=>"83.52", "Total Value"=>"8255.78"}, {"Investment Name"=>"VANGUARD TOTAL STOCK MARKET ETF", "Symbol"=>"VTI", "Shares"=>"366.581", "Share Price"=>"107.30", "Total Value"=>"39334.14"}, {"Investment Name"=>"VANGUARD REIT INDEX ETF", "Symbol"=>"VNQ", "Shares"=>"78", "Share Price"=>"76.59", "Total Value"=>"5974.02"}], "66666666"=>[{"Investment Name"=>"AMAZON.COM INC", "Symbol"=>"AMZN", "Shares"=>"3", "Share Price"=>"436.04", "Total Value"=>"1308.12"}, {"Investment Name"=>"SPDR GOLD TRUST GOLD SHARES", "Symbol"=>"GLD", "Shares"=>"16", "Share Price"=>"112.06", "Total Value"=>"1792.96"}, {"Investment Name"=>"TESLA MOTORS INC", "Symbol"=>"TSLA", "Shares"=>"5", "Share Price"=>"279.72", "Total Value"=>"1398.60"}]}

      expect(current_data.funds).to eq(output)
    end
  end
end

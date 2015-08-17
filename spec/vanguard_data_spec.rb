require_relative '../vanguard_csv'

RSpec.describe VanguardCSV do
  context '#initialize' do
    it 'sets path' do
      current_data = VanguardCSV.new('spec/test_data/', 'simple.csv')
      current_data.path_to_csv == 'spec/test_data/simple.csv'
    end
  end

  context '#parse_downloaded_csv' do
    it 'pulls data into @sections' do
      current_data = VanguardCSV.new('spec/test_data/', 'simple.csv')
      current_data.send(:parse_downloaded_csv)
      output = [[["Fund Account Number", "Fund Name", "Price", "Shares", "Total Value", nil], [], ["0030-11111111111", "Vanguard Prime Money Market Fund", "1.00", "130.680", "130.68", nil], [], []], [["Account Number", "Trade Date", "Process Date", "Transaction Type", "Transaction Description", "Investment Name", "Share Price", "Shares", "Gross Amount", "Net Amount", nil], ["22222222222", "07/02/2015", "07/02/2015", "Buy", "NET SWEEP FROM BROKERAGE", "Prime Money Mkt Fund", "1.0", "59.44", "59.44", "59.44", nil], [], []], [["Account Number", "Investment Name", "Symbol", "Shares", "Share Price", "Total Value", nil], ["44444444", "VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "VXUS", "60.4", "49.63", "2997.65", nil]]]

      expect(current_data.sections).to eq(output)

    end
  end

  context '#remove_trade_data' do
    it 'gets rid of trade data' do
      current_data = VanguardCSV.new('spec/test_data/', 'simple.csv')
      current_data.send(:parse_downloaded_csv)
      current_data.send(:remove_trade_data)

      output = [[["Fund Account Number", "Fund Name", "Price", "Shares", "Total Value", nil], [], ["0030-11111111111", "Vanguard Prime Money Market Fund", "1.00", "130.680", "130.68", nil], [], []], [["Account Number", "Investment Name", "Symbol", "Shares", "Share Price", "Total Value", nil], ["44444444", "VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "VXUS", "60.4", "49.63", "2997.65", nil]]]

      expect(current_data.sections).to eq(output)
    end
  end

  context '#build_helper_csvs' do
    it 'builds helper CSVs' do
      data = 'spec/test_data/'
      current_data = VanguardCSV.new(data, 'simple.csv')
      current_data.instance_eval('@sections=[[[1,2],[],[3,4]]]')
      
      current_data.send(:build_helper_csvs)

      csv_array = []
      CSV.foreach(data + 'tmp/0.csv') do |line|
        csv_array << line
      end
      expect(csv_array).to eq([["1","2"],["3","4"]])
    end
  end

  context '#parse_helper_csvs' do
    it 'parses helper CSVs' do
      current_data = VanguardCSV.new('spec/test_data/', 'simple.csv')
      current_data.instance_eval('@sections = [0,1]')

      current_data.send(:parse_helper_csvs,'tmp_csvs/')
      output = {"0030-11111111111"=>[{"Fund Name"=>"Vanguard Prime Money Market Fund", "Price"=>"1.00", "Shares"=>"130.680", "Total Value"=>"130.68"}], "44444444"=>[{"Investment Name"=>"VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "Symbol"=>"VXUS", "Shares"=>"60.4", "Share Price"=>"49.63", "Total Value"=>"2997.65"}]}
      expect(current_data.funds).to eq(output)
    end
  end

  context '#get_acccounts' do
    it 'returns the accounts' do
      current_data = VanguardCSV.new('spec/test_data/', 'simple.csv')
      current_data.get_accounts

      output = {"0030-11111111111"=>[{"Fund Name"=>"Vanguard Prime Money Market Fund", "Price"=>"1.00", "Shares"=>"130.680", "Total Value"=>"130.68"}], "44444444"=>[{"Investment Name"=>"VANGUARD TOTAL INTL STOCK INDEX FUND ETF", "Symbol"=>"VXUS", "Shares"=>"60.4", "Share Price"=>"49.63", "Total Value"=>"2997.65"}]}

      expect(current_data.funds).to eq(output)
    end
  end

  context '#get_investments' do
    it 'creates investments' do
      current_data = VanguardCSV.new('spec/test_data/', 'simple.csv')
      current_data.instance_eval('@funds={3=>[{"Symbol"=>"a","Shares"=>3,"Share Price"=>10,"Total Value"=>30,"Investment Name"=>"A"}]}')
      current_data.get_investments
      investment = current_data.investments[0]

      output = Investment.new("A", "a", 3, 10, 30, 3)

      expect(investment.name).to eq(output.name)
      expect(investment.symbol).to eq(output.symbol)
      expect(investment.share_price).to eq(output.share_price)
      expect(investment.total_value).to eq(output.total_value)
      expect(investment.shares).to eq(output.shares)
      expect(investment.account_number).to eq(output.account_number)
    end
  end
end

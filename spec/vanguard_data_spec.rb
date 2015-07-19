require_relative '../vanguard_data'

RSpec.describe VanguardData do
  context '#initialize' do
    it 'sets path' do
      current_data = VanguardData.new('data/ofxdownload.csv')
      current_data.path_to_csv == 'data/ofxdownload.csv'
    end
  end
end

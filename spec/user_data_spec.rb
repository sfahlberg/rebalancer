require_relative '../user_data.rb'

RSpec.describe UserData do
  describe '#initialize' do
    context "with valid input data" do
      it "returns expected output" do
        current_data = UserData.new('spec/test_data/')
        current_data.path == 'spec/test_data/'
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#create_portfolios' do 
    context "with valid input data" do
      it "returns expected output" do
        current_data = UserData.new('spec/test_data/')
        inv_a = Investment.new("A", "a", 3, 5, 15, "0030-33333333333")
        inv_b = Investment.new("B", "b", 2, 4, 8, "44444444")
        inv_c = Investment.new("C", "c", 5, 7, 35, "3")
        investments = [inv_a, inv_b, inv_c]

        output = current_data.create_portfolios(investments)
        portfolio = Portfolio.new("traditional", ["0030-33333333333", "44444444"], [inv_a, inv_b]) 

        expect(output[0].name).to eq(portfolio.name)
        expect(output[0].investments).to eq(portfolio.investments)
        expect(output[0].account_numbers).to eq(portfolio.account_numbers)
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#fetch_user_data_from_json' do
    context 'with valid input data' do 
      it 'returns expected output'
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#set_credentials' do
    context 'with valid input data' do 
      it 'returns expected output'
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#set_portfolio_of_investment_equal_to_current_portfolio' do
    context 'with valid input data' do 
      it 'returns expected output'
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end
  describe '#set_portfolios' do
    context 'with valid input data' do 
      it 'returns expected output'
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end
end

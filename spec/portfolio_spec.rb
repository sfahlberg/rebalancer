require_relative '../portfolio.rb'

RSpec.describe Portfolio do
  describe '#initialize' do
    context "with valid input data" do
      it "returns expected output" do
        portfolio = Portfolio.new("test", [1,2], ["inv1", "inv2"])

        expect(portfolio.name).to eq("test")
        expect(portfolio.account_numbers).to eq([1,2])
        expect(portfolio.investments).to eq(["inv1", "inv2"])
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#calculate_portfolio_total_value' do
    context "with valid input data" do
      it "returns expected output" do
        inv_1 = Investment.new('one', 'ONE', 3, 7, 21, 111)
        inv_2 = Investment.new('two', 'TWO', 4, 8, 32, 222)
        portfolio = Portfolio.new("test", [1,2], [inv_1, inv_2])

        portfolio.calculate_portfolio_total_value

        expect(portfolio.portfolio_total_value).to eq(53)
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end
end

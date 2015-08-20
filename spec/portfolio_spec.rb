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
end

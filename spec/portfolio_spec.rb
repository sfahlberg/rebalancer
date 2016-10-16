require_relative '../portfolio.rb'

RSpec.describe Portfolio do
  describe '#initialize' do
    context "with valid input data" do
      it "returns expected output" do
        inv_1 = Investment.new('one', 'ONE', 3, 7, 21, 111)
        inv_2 = Investment.new('two', 'TWO', 4, 8, 32, 222)
        portfolio = Portfolio.new("test", [1,2], [inv_1, inv_2])

        expect(portfolio.name).to eq("test")
        expect(portfolio.account_numbers).to eq([1,2])
        expect(portfolio.investments).to eq([inv_1, inv_2])
        expect(portfolio.total_value).to eq(53)
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#determine_buy_or_sell' do
    context "with valid input data" do
      it "returns sell as true" do
        inv_a = Investment.new("a", "A", 3, 10, 30, 111)
        inv_a.current_percentage = 75
        inv_a.desired_percentage = 50

        inv_b = Investment.new("b", "B", 1, 10, 10, 222)
        inv_b.current_percentage = 25
        inv_b.desired_percentage = 50

        port = Portfolio.new("x", [], [inv_a, inv_b])

        port.determine_buy_or_sell

        expect(port.buy).to be false
        expect(port.sell).to be true
      end

      it "returns buy as true" do
        inv_a = Investment.new("a", "A", 1, 10, 10, 111)
        inv_a.current_percentage = 25
        inv_a.desired_percentage = 50

        inv_b = Investment.new("b", "B", 2, 10, 10, 222)
        inv_b.current_percentage = 25
        inv_b.desired_percentage = 50

        inv_mma = Investment.new("mma", "VMFXX", 20, 1, 20, 333)
        inv_mma.current_percentage = 50
        inv_mma.desired_percentage = 0

        port = Portfolio.new("x", [], [inv_a, inv_b, inv_mma])

        port.determine_buy_or_sell

        expect(port.buy).to be true
        expect(port.sell).to be false
      end

      it "returns buy and sell as false" do
        inv_a = Investment.new("a", "A", 1, 47, 47, 111)
        inv_a.current_percentage = 47
        inv_a.desired_percentage = 50

        inv_b = Investment.new("b", "B", 1, 47, 47, 222)
        inv_b.current_percentage = 47
        inv_b.desired_percentage = 50

        inv_mma = Investment.new("mma", "VMFXX", 1, 6, 6, 333)
        inv_mma.current_percentage = 6
        inv_mma.desired_percentage = 0

        port = Portfolio.new("x", [], [inv_a, inv_b, inv_mma])

        port.determine_buy_or_sell

        expect(port.buy).to be false
        expect(port.sell).to be false
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end
end

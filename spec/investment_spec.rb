require_relative '../investment.rb'

RSpec.describe Investment do
  describe '#initialize' do
    context "with valid input data" do
      it "returns expected output" do
        investment = Investment.new("inv_name", "SYM", 4, 7, 28, 111)

        expect(investment.name).to eq("inv_name")
        expect(investment.symbol).to eq("SYM")
        expect(investment.shares).to eq(4)
        expect(investment.share_price).to eq(7)
        expect(investment.total_value).to eq(28)
        expect(investment.account_number).to eq(111)
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#symbolize_mma' do
    context "with valid input data" do
      it "takes MMA and makes symbol MMA" do
        inv = Investment.new('Vanguard Prime Money Market Fund', nil, 1, 1, 1, 11) 
        inv.symbolize_mma
        expect(inv.symbol).to eq("MMA")
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#calculate_share_price' do
    context "with valid input data" do
      it "calculates share price if nil" do
        inv = Investment.new('A', 'a', 3, nil, 12, 11) 
        inv.calculate_share_price
        expect(inv.share_price).to equal(4.0)
      end

      it "calculates share price if incorrect" do
        inv = Investment.new('A', 'a', 3, 5, 12, 11) 
        inv.calculate_share_price
        expect(inv.share_price).to equal(4.0)
      end
      
      it "calculates float share price" do
        inv = Investment.new('A', 'a', 3, 4, 12, 11) 
        inv.calculate_share_price
        expect(inv.share_price).to equal(4.0)
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#calculate_desired_percentage' do
    context "with valid input data" do
      it "calculates the percentage desired" do
        # portfolio = Portfolio.new('test_name',[],[])
        # inv = Investment.new()
        #
        # expect(inv.desired_percentage).to eq(35)
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#calculate_current_percentage' do
    context "with valid input data" do
      it "does something" 
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#calculate_desired_value' do
    context "with valid input data" do
      it "does something" 
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end
end

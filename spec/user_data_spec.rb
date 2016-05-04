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

  describe "#get_desired_portfolios" do
    context "with valid input data" do
      it "returns expected output" do
        current_data = UserData.new('spec/test_data/')
        portfolios = {"traditional"=>{"a"=>33.0, "b"=>33.0, "c"=>34.0}}
        output = current_data.get_desired_portfolios
        expect(output).to eq(portfolios) 
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
        portfolio = Portfolio.new("traditional", {"0030-33333333333"=>true, "44444444"=>true}, [inv_a, inv_b]) 

        expect(output[0].name).to eq(portfolio.name)
        expect(output[0].investments).to eq(portfolio.investments)
        expect(output[0].account_numbers).to eq(portfolio.account_numbers)
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end

  describe '#get_portfolios' do
    context "with valid input data" do
      it "returns expected output" do
        current_data = UserData.new('spec/test_data/')
        inv_a = Investment.new("A", "a", 3, 5, 15, "0030-11111111111")
        inv_b = Investment.new("B", "b", 2, 4, 8, "22222222")
        inv_c = Investment.new("C", "c", 5, 7, 35, "3")
        investments = [inv_a, inv_b, inv_c]

        output = current_data.get_portfolios(investments)
        # portfolio = Portfolio.new("after-tax", {"0030-11111111111"=>true, "22222222"=>true}, [inv_a, inv_b]) 

        output.each do |portfolio|
          if portfolio.name == "traditional"
            portfolio.investments.each do |inv|
              if inv.symbol == "a"
                expect(inv.desired_percentage).to eq(33)
              end
            end
          end
        end
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end
end

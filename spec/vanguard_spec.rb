require_relative '../vanguard.rb'

RSpec.describe Vanguard do
  describe '#initialize' do
    context "with valid input data" do
      it "returns expected output" do
        vanguard = Vanguard.new("X")
        expect(vanguard.portfolios).to eq("X")
      end
    end

    context "with invalid input data" do
      it "throws an error"
    end
  end
end

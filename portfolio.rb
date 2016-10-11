require_relative 'investment'

class Portfolio
  attr_reader :name, :investments, :account_numbers
  attr_accessor :total_value, :sell, :buy

  def initialize(name, account_numbers, investments)
    @name = name
    @account_numbers = account_numbers
    @investments = investments
    @total_value = 0
    @diff_for_action = 5
    @buy = false
    @sell = false
    calculate_total_value
  end

  def calculate_total_value
    @investments.each do |investment|
      @total_value += investment.total_value
    end
  end

  def amount_to_buy_or_sell
    @investments.each do |inv|
      next if inv.symbol == "VMMXX"
      inv.determine_change_in_shares({buy: @buy, sell: @sell})
    end
  end

  def determine_buy_or_sell
    @investments.each do |inv|
      next if inv.symbol == "VMFXX"

      diff = inv.current_percentage - inv.desired_percentage

      if diff > @diff_for_action
        @sell = true
      end
    end

    # if you're not selling, check if you should buy
    if !@sell
      @investments.each do |inv|
        next if inv.symbol == "VMFXX"

        diff = inv.current_percentage - inv.desired_percentage

        if diff < -@diff_for_action
          @buy = true
        end
      end
    end
  end
end

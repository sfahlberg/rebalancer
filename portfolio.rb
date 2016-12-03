require_relative 'investment'

class Portfolio
  attr_reader :name, :investments, :account_numbers
  attr_accessor :total_value, :sell, :buy

  def initialize(name, account_numbers, investments)
    @name = name
    @account_numbers = account_numbers
    @investments = investments
    @total_value = 0
    @diff_for_action = 3
    @buy = false
    @sell = false
    @settlement_account_symbol = 'VMFXX'
    calculate_total_value
  end

  def calculate_total_value
    @investments.each do |investment|
      @total_value += investment.total_value
    end
  end

  def amount_to_buy_or_sell
    @investments.each do |inv|
      next if inv.symbol == @settlement_account_symbol
      inv.determine_change_in_shares({buy: @buy, sell: @sell})
    end
  end

  def determine_buy_or_sell
    should_sell
    # if you're not selling, check if you should buy
    should_buy unless @sell
  end

  def should_sell
    # check whether any of the non-settlement investments is over the
    # @diff_for_action amount if so sell that
    @investments.each do |inv|
      next if inv.symbol == @settlement_account_symbol
      diff = inv.current_percentage - inv.desired_percentage
      @sell = true if diff > @diff_for_action
    end
  end

  def should_buy
    @investments.each do |inv|
      diff = inv.current_percentage - inv.desired_percentage
      # check whether any settlement account has more the @diff_for_action amount
      @buy = true if inv.symbol == @settlement_account_symbol && diff > @diff_for_action
      # check whether non-settlement accoutn investments have less than
      # the negative @diff_for_action
      @buy = true if diff < -@diff_for_action
    end
  end
end

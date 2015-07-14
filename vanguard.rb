include Parser
class Vanguard
  require 'csv'
  require_relative 'helpers'
  require_relative 'portfolio'
  attr_reader :portfolios

  def initialize
    Portfolio.get_investments
    @portfolios = get_portfolios
  end
end

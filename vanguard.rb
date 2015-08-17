class Vanguard
  require_relative 'helpers'
  require_relative 'portfolio'
  attr_reader :portfolios

  def initialize(portfolios)
    @portfolios = portfolios
  end
end

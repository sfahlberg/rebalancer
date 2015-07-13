require_relative 'parser'
require_relative 'algorithm'
require_relative 'vanguard'
require 'rubygems'
require 'byebug'

# accounts = get_accounts
# crunch_numbers(accounts)
#
my_vanguard_account = Vanguard.new
p my_vanguard_account.portfolios

require 'bundler'
Bundler.require

require 'csv'
require_relative 'carddb'
require_relative 'reports/day_of_week'
require_relative 'reports/top_cards'
require_relative 'reports/top_users'
require_relative 'reports/most_cards'

csv = CSV.open('logfile.csv').to_a
carddb = CardDB.new('formatted.json')

DayOfWeek.new(csv).run
TopCards.new(csv).run
TopUsers.new(carddb, csv).run
MostCards.new(carddb).run


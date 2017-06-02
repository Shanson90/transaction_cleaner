require_relative 'classes/klean.rb'
require_relative 'classes/rule.rb'
require_relative 'classes/csv_output'

OUTPUT_FOLDER = '/Users/swilliamson/Personal Master/Personal Finance/'

input_file = Klean.new('/Users/swilliamson/Personal Master/Personal Finance/2016/12.31/Citi_data.csv')
input_file.import

rule = Rule.new
rules = rule.get_all_rules
input_file.apply_rules(rules)

clean_transactions = input_file.klean_transactions
output = CsvOutput.new("#{OUTPUT_FOLDER}2016/12.31/Citi_output.csv", clean_transactions)
output.create_csv

input_file
input_file.puts_data

require_relative 'classes/klean.rb'
require_relative 'classes/rule.rb'

input_file = Klean.new('/Users/swilliamson/Personal Master/Personal Finance/2016/12.31/Citi_data.csv')
input_file.import

rule = Rule.new
rules = rule.get_all_rules
input_file.apply_rules(rules)

clean_transactions = input_file.klean_transactions
output = CsvOutput.new(clean_transactions)

input_file
input_file.puts_data

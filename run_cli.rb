require_relative 'classes/klean'
require_relative 'classes/rule'
require_relative 'classes/csv_output'
require_relative 'classes/cli'

PRIMARY_DIR = '/Users/swilliamson/Personal Master/Personal Finance/2016/12.31'
YEAR = 2016
MONTH = 12
DAY = 31

cli = CLI.new

input_file = Klean.new(cli.input_file)
input_file.import

rule = Rule.new
rules = rule.get_all_rules
input_file.apply_rules(rules)

clean_transactions = input_file.klean_transactions
output = CsvOutput.new("#{PRIMARY_DIR}#{YEAR}/#{MONTH}.#{DAY}/Citi_output.csv", clean_transactions)
output.create_csv

input_file
input_file.puts_data

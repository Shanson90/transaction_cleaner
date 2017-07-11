require_relative 'classes/klean'
require_relative 'classes/rule'
require_relative 'classes/csv_output'
require_relative 'classes/cli'

PRIMARY_DIR = '/Users/swilliamson/Personal Master/Personal Finance/2016/12.31'
YEAR = 2016
MONTH = 12
DAY = 31

cli = CLI.new
cli.run_cli
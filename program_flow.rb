input_file = Klean.new('/Users/swilliamson/Personal Master/Personal Finance/2016/12.31/Citi_data.csv')
input_file.import
input_file.map_saved_data

input_file.puts_data
input_file.categorize_transactions
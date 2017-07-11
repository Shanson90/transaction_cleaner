require 'colorize'
class CLI

  DIR_MSG = 'Enter the path to the directory you want to use.'
  INPUT_FILE_MSG = 'What\'s the name of the file you want to clean?'
  ME_DATE_MSG = "Enter the month for the output file name. \n(name, 3 letter abreviation, and number are all fine)"
  YEAR_MSG = 'Enter the year.'
  DATE_MSG = "Enter the date to use for the output file. \n(or just hit enter to skip)"
  HELP_MSG = 'Here is a list of available commands:'
  NAME_FILE_MSG = 'What would you like to name the output file?'
  ADD_RULE_MSG = <<input
To add a rule, you'll need a match pattern (regular expression)
and 1 to 3 fields you want to set with specific values. 

For example:
Regular Expression: /\\sPhilly\\s/
1) Field: city , Value: Philadelphia
2) Field: state , Value: PA                   (optional - only one field/value pair is required for a given match pattern)
3) Field: reasonable location , Value: true   (optional - you can set up to 3 field/value pairs for a given match pattern)

Ok... here we go. First enter the match pattern as a regular expression.
input
  WELCOME_MSG = <<input
Hi. I\'m TC. I take dirty transaction data from banks and credit card companies and turn it into one big CSV 
file that is cleaned according to your custom cleaning rules.

Try typing 'help' for a list of available commands.
input

  # Startup the interface
  def initialize
    system 'clear' or system 'cls'
    puts WELCOME_MSG
  end

  def run_cli
    input = ''
    until input == 'exit'
      input = gets.chomp.downcase
      puts "\n"
      send input
      puts "\nCommand?".colorize(:light_cyan)
    end
  end


  # Display methods available to user
  def help
    puts HELP_MSG
    if @methods == nil
      @methods = CLI.public_instance_methods(false)
    end

    @methods.each do |method|
      puts method.to_s.colorize(:light_cyan) unless method.to_s.include?('=')
    end
    puts 'exit'.colorize(:light_cyan)
  end


  # View variables
  def date
    if @date.nil?
      puts 'The date has not been set.'.colorize :red
      puts "(try #{'set_date'.colorize :light_cyan} to set one)"
    else
      puts "date: #{@date_str}"
    end
  end

  def input_file
    if @input_path.nil?
      puts 'The input file has not been set.'.colorize :red
      puts "(Try #{'set_input_file'.colorize(:light_cyan)} to set it)"
    else
      puts "input file: #{@input_path}"
    end
    @input_path
  end

  def output_file
    if @output_file_path.nil?
      name_output
    end
    puts "output file: #{@output_file_path}"
  end


  # Set variables
  def set_date
    @date = get_date
    @date_str = @date.strftime('%Y.%m.%d')
    date
  end

  def set_input_file
    get_input_dir
    get_input_file_name
    @input_path = "#{@dir}/#{@file}"
    input_file
  end

  def name_output
    puts NAME_FILE_MSG
    output_file_word = gets.chomp
    set_date
    @output_file_name = "#{@date_str} #{output_file_word}"
    if @dir == nil
      get_input_dir
    end
    @output_file_path = "#{@dir}/#{@output_file_name}"
    puts "output file: #{@output_file_path}"
  end


  # Manipulate rules
  def add_rule
    puts ADD_RULE_MSG.colorize :yellow
    regex = Regexp.new(gets.chomp)
    fields_and_values = get_fields_and_values
    @rule = Rule.new
    @rule.add(regex, fields_and_values)
  end

  def view_rules

  end

  def delete_rule

  end


  # Do work
  def process_input_file
    input_file = Klean.new(@input_path)
    input_file.import

    rule = Rule.new
    rules = rule.get_all_rules
    input_file.apply_rules(rules)

    clean_transactions = input_file.klean_transactions
    output = CsvOutput.new("#{PRIMARY_DIR}#{YEAR}/#{MONTH}.#{DAY}/Citi_output.csv", clean_transactions)
    output.create_csv

    input_file
    input_file.puts_data
  end

  private

  # def method_missing(m)
  #   puts "Hmm, don't recognize that command... Try again?"
  #   help
  #   run_cli
  # end

  def get_input_dir
    puts DIR_MSG
    @dir = gets.chomp
  end

  def get_input_file_name
    puts INPUT_FILE_MSG
    @file = gets.chomp
  end

  def get_date
    puts DATE_MSG
    date = gets.chomp
    begin
      Date.parse(date)
    rescue
      puts "\nUnable to parse date... try YYYY.MM.DD format.".colorize :yellow
      get_date
    end
  end

  def get_fields_and_values
    raw_input = 'start'
    fields_and_values = {}

    until raw_input == '' || fields_and_values.length >= 3
      puts "Enter a single field-value pair in the format 'field:value'"
      puts '(If you\'re done adding fields and values for this rule, just hit enter)'
      raw_input = gets.chomp
      unless raw_input == ''
        input = raw_input.split(':')
        fields_and_values[input[0]] = input[1]
      end
    end
    fields_and_values
  end

end
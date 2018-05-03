require 'colorize'
require_relative '../classes/settings'
require_relative './klean'
require_relative './csv_output'

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
    @settings = Settings.new
  end

  def run_cli
    input = ''
    until input == 'exit'
      begin
        input = gets.chomp.downcase
        puts "\n"
        send input
      rescue NoMethodError
        puts "Hmm, #{input} isn't a recognized command."
        puts "Try again?"
        retry
      end

      puts "\nCommand?".colorize(:cyan)
    end
  end


  # Display methods available to user
  def help
    puts HELP_MSG
    @methods ||= CLI.public_instance_methods(false)

    @methods.each do |method|
      puts method.to_s.colorize(:cyan) unless method.to_s.include?('=')
    end
    puts 'exit'.colorize(:cyan)
  end


  # View variables
  def date
    puts "The current date is: #{@settings.date.strftime('%Y.%m.%d')}"
    puts "(try #{'set_date'.colorize :cyan} to change it)"
  end

  def input_file
    if @settings.input_file.nil?
      puts 'The input file has not been set.'.colorize :red
      puts "(Try #{'set_input_file'.colorize(:cyan)} to set it)"
    else
      puts "input file: #{@settings.input_file}"
    end
    @input_path
  end

  def output_file
    if @settings.output_file.nil?
      name_output
    end
    puts "output file: #{@settings.output_file}"
  end


  # Set variables
  def set_date
    date = get_date
    @settings.set_date(date)
    @date_str = date.strftime('%Y.%m.%d')
  end

  def set_input_file
    get_input_dir
    get_input_file_name
    input_path = build_path(@dir, @file)
    @settings.set_input_file(input_path)
    input_file
  end

  def name_output
    puts NAME_FILE_MSG
    output_file_word = gets.chomp
    output_file_name = "#{@settings.date.strftime('%Y.%m.%d')} #{output_file_word}"
    @settings.set_output_file(build_path(File.dirname(@settings.input_file), output_file_name))
    puts "output file: #{@settings.output_file}"
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
    input_file = Klean.new(@settings.input_file)
    input_file.import

    rule = Rule.new
    rules = rule.get_all_rules
    input_file.apply_rules(rules)

    clean_transactions = input_file.klean_transactions
    output = CsvOutput.new(@settings.output_file, clean_transactions)
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
    date
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

  def build_path(directory, file_name)
    "#{directory}/#{file_name}"
  end

end
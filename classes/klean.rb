require 'colorize'
require 'smarter_csv'
require_relative 'rule.rb'

class Klean
  attr_reader :klean_transactions

  def initialize(file_path)
    @input_file_path = file_path
    @klean_transactions = []
  end

  def import
    @all_transactions = SmarterCSV.process(@input_file_path)
  end

  def apply_rules(rules)
    @all_transactions.each do |transaction|
      @transaction = transaction
      rules.each do |rule|
        unless rule[:match_pattern].match(@transaction[:description]) == nil
          rule.each_pair do |field, value|
            next if field == :match_pattern
            @transaction[field] = value
          end
        end
      end
      @klean_transactions << @transaction
    end
  end

  def puts_data
    puts "\nOutput from 'puts_data' method:".colorize(:red)
    @klean_transactions.each do |transaction|
      puts transaction
    end
  end

  ######################## OLD & UNUSED #############################
  private

  def set_amount_type
    if @transaction[:debit] == nil
      @transaction[:amount_type] = 'credit'
    elsif @transaction[:credit] == nil
      @transaction[:amount_type] = 'debit'
    else
      Raise(RuntimeError, 'The transaction did not have an associated debit or credit')
    end
  end

  def set_amount
    type = @transaction[:amount_type]
    amount = remove_commas(@transaction[type.to_sym]).to_f

    if @transaction[:amount_type] == 'credit'
      amount = -amount
    end

    @transaction[:amount] = amount
  end

  def remove_commas(potential_string)
    if potential_string.is_a?(String)
      potential_string.delete!(',')
    end
    potential_string
  end

end
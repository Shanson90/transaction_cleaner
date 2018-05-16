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
    @original_transactions = SmarterCSV.process(@input_file_path)
    @transactions = @original_transactions
  end

  def clean_headers
    header = Header.new
    header_rules = header.get_all
    new_headers = []

    @transactions.map! do |transaction|
      header_rules.each do |rule|
        new_headers << rule[:new_header] unless new_headers.include?(rule[:new_header])
        transaction.keys.each do |key|
          unless rule[:match_pattern].match(key) == nil
            transaction[rule[:new_header]] = transaction[key]
          end
        end
      end
      transaction
    end
    new_headers
  end

  def clean_column(name)
    rule = Rule.new
    rules = rule.get_rules_by_type(name.to_s)
    apply_rules(rules, name.to_sym)
  end

  def clean_amounts
    unify_debits_and_credits
  end

  def puts_data
    puts "\nOutput from 'puts_data' method:".colorize(:red)
    @transactions.each do |transaction|
      puts transaction
    end
  end

  def unify_debits_and_credits
    @transactions.each do |transaction|
      next if transaction[:debit].nil? && transaction[:credit].nil?
      set_amount_type(transaction)
      set_amount(transaction)
    end

  end

  private

  def apply_rules(rules, target_col)
    @transactions.each do |transaction|
      rules.each do |rule|
        unless rule[:match_pattern].match(transaction[target_col]) == nil
          rule.each_pair do |field, value|
            next if field == :match_pattern
            transaction[field] = value
          end
        end
      end
      @klean_transactions << transaction
    end
    @transactions = @klean_transactions
    @klean_transactions = []
  end

  def set_amount_type(transaction)
    if transaction[:debit] == nil
      transaction[:amount_type] = 'credit'
    elsif transaction[:credit] == nil
      transaction[:amount_type] = 'debit'
    end
  end

  def set_amount(transaction)
    type = transaction[:amount_type]
    amount = remove_commas(transaction[type.to_sym]).to_f

    if transaction[:amount_type] == 'credit'
      amount = -amount
    end

    transaction[:amount] = amount
  end

  def remove_commas(potential_string)
    if potential_string.is_a?(String)
      potential_string.delete!(',')
    end
    potential_string
  end

end
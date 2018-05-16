class Citi

  def initialize(transactions, rules)
    @original_transactions = transactions
    @rules = rules
    @klean_transactions = []
  end

  def apply_rules(rules)
    @original_transactions.each do |transaction|
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

end
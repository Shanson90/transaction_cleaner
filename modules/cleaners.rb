module Cleaners
  extend self

  def clean_description(text) # converts +text+ to array of strings with no spaces
    new_description = []
    words = text.squeeze(' ').split
    words.each { |word| new_description << clean_word(word) unless clean_word(word) == nil }
    new_description
  end

  def clean_word(word) #applies rule for first matching specific case, or defaults to capitalized +word+
    if state_abreviation?(word) || usa?(word)
      word.upcase
    end

    if squar?(word)
      return 'Square'
    end

    word.capitalize
  end

  def clean_amount(amount, is_credit = false) # returns float, which is negated if +is_credit+
    amount = remove_commas(amount).to_f

    if is_credit
      amount = -amount
    end

    amount
  end

  private

  def usa?(word)
    if word.upcase == 'USA'
      return true
    end
    false
  end

  def squar?(word) # common truncation of city names with 'Square' in them, like 'Kennet Square'
    word.downcase == 'squar'
  end

  def remove_commas(potential_string)
    if potential_string.is_a?(String)
      potential_string.delete!(',')
    end
    potential_string
  end
end
require 'colorize'
require 'smarter_csv'

class Klean

  SavedMerchants = [%w(Chick-fil-a Staples Spotify Wawa Walmart Starbucks Cosi Wendys Petsmart Firestone Deals Sunoco At&t Dollartree Giordanos Shell)]

  SavedCities = [%w(Kennet Square), %w(Glen Mills), %w(New York), %w(Brooklyn), %w(Concordville), %w(Philadelphia), %w(Media), %w(Wilmington), %w(Denver), %w(Littleton)]

  SavedData = [

  # Template:
  # {
  #   match_pattern: //,
  #   field: 'value'
  # }

    # Merchants
    {
        match_pattern: /GIORDANOS\s+PIZZA\s+/,
        merchant: 'Gio\'s Pizza',
        category: 'Drugs & Alcohol'
    },
    {
        match_pattern: /CHICK-FIL-A\s#\d+\s+/,
        merchant: 'Chick-fil-a',
        category: 'Eating Out'
    },
    {
        match_pattern: /Spotify/,
        merchant: 'Spotify',
        category: 'Entertainment'
    },
    {
        match_pattern: /WAWA\s+\d+\s+\d+/,
        merchant: 'Wawa',
        category: 'Eating Out'
    },
    {
        match_pattern: /WM\s+SUPERCENTER\s+#\d+/,
        merchant: 'Walmart',
        category: 'Groceries'
    },
    {
        match_pattern: /STARBUCKS\s+STORE\s\d+/,
        merchant: 'Starbucks',
        category: 'Eating Out'
    },
    {
        match_pattern: /APL\*\s+ITUNES\.COM\/BILL/,
        merchant: 'Netflix',
        category: 'Entertainment'
    },
    {
        match_pattern: /WENDYS\s+#\d+-\d+/,
        merchant: 'Wendy\'s',
        category: 'Eating Out'
    },
    {
        match_pattern: /STONEY\s+CREEK\s+VET/,
        merchant: 'Stoney Creek Vet',
        category: 'Pet Care'
    },
    {
        match_pattern: /H&M\s+#\d+/,
        merchant: 'H&M',
        category: 'Clothing'
    },
    {
        match_pattern: /EXXONMOBILE\s+\d+\s+/,
        merchant: 'Exxon',
        category: 'Gas'
    },

    # Special Cases
    {
        match_pattern: /AUTOPAY\s+\d+.*AUTOPAY\s+AUTO-PMT/,
        merchant: 'Citi Bank',
        category: 'Balance Sheet',
        clean_description: 'Double Cash Credit Card Pmt'
    },

    # Cities
    {
        match_pattern: /KENNET.*SQ/,
        city: 'Kennet Square'
    },
    {
        match_pattern: /GLEN MILLS/,
        city: 'Glen Mills'
    },
    {
        match_pattern: /NEW\s+YORK/,
        city: 'New York'
    },
    {
        match_pattern: /\sCONCORDVILLE\s/,
        city: 'Concordville'
    },
    {
        match_pattern: /\sPHILLY/,
        city: 'Philadelphia'
    },
    {
        match_pattern: /\sPHILADELPHIA/,
        city: 'Philadelphia'
    },
    {
        match_pattern: /\sBROOKLYN/,
        city: 'Brooklyn'
    },
    {
        match_pattern: /\sMEDIA/,
        city: 'Media'
    },
    {
        match_pattern: /\sMORTON/,
        city: 'Morton'
    },
    {
        match_pattern: /\sSPRINGFIELD/,
        city: 'Springfield'
    },
    {
        match_pattern: /\sWOODLYN/,
        city: 'Woodlyn'
    },
    {
        match_pattern: /\sCHARLOTTE/,
        city: 'Charlotte'
    },
    {
        match_pattern: /\sMONROE/,
        city: 'Monroe'
    },

    # States
    {
        match_pattern: /\sPA/,
        state: 'PA'
    },
    {
        match_pattern: /\sNY/,
        state: 'NY'
    },
    {
        match_pattern: /\sCA/,
        state: 'CA'
    },
    {
        match_pattern: /\sDE/,
        state: 'DE'
    },
    {
        match_pattern: /\sWA/,
        state: 'WA'
    },
    {
        match_pattern: /\sTX/,
        state: 'TX'
    },
    {
        match_pattern: /\sVA/,
        state: 'VA'
    },
    {
        match_pattern: /\sMD/,
        state: 'MD'
    },
    {
        match_pattern: /\sNC/,
        state: 'NC'
    },
  ]

  def initialize(file_path)
    puts "\n---------- NEW KLEAN ----------\n-------------------------------\n ".colorize(:light_cyan)
    @input_file_path = file_path
  end

  def import
    @data = SmarterCSV.process(@input_file_path)
  end

  def map_saved_data
    @data.each do |transaction|
      @transaction = transaction
      SavedData.each do |rule|
        unless rule[:match_pattern].match(@transaction[:description]) == nil
          rule.each_pair do |field, value|
            next if field == :match_pattern
            @transaction[field] = value
          end
        end
      end
    end
  end

  def make_pretty
    @data.each do |transaction|
      next if transaction[:description] == nil
      @transaction = transaction
      clean_description
      set_amount_type
      set_amount
    end
  end

  def scrape_descriptions
    @data.each do |transaction|
      @transaction = transaction
      next if @transaction[:description] == nil
      set_known_city
      set_known_merchant
      remove_merchant_from_description
      remove_empty_description
    end
  end

  def replace_mapped_transactions
    @data.map! do |transaction|
      replacement = is_mapped?(transaction)
      if replacement == false
        transaction
      else
        SavedTransactions[replacement]
      end
    end
  end

  def categorize_transactions

  end

  def export

  end

  def puts_data
    @data.each do |row|
      if row[:merchant] == nil
        puts row[:description]
      end
    end
  end

  private

  def set_known_merchant
    SavedMerchants.each do |merchant|
      @transaction[:description].each do |word|
        if word.capitalize == merchant
          @transaction[:merchant] = merchant
        end
      end
    end
  end

  def set_known_city
    SavedCities.each do |city|
      if (city - @transaction[:description]).empty?
        @transaction[:description] -= city
        @transaction[:city] = city.join(' ')
      end
    end
  end

  def is_mapped?(transaction)
    SavedTransactions.each_pair do |saved_transaction_name, saved_transaction|

      date_match = transaction[:date] == saved_transaction[:date]
      text_match = transaction[:description] == saved_transaction[:match_text]
      merchant_match = transaction[:merchant] == saved_transaction[:merchant]
      amount_match = transaction[:debit] == saved_transaction[:amount] || transaction[:credit] == saved_transaction[:amount]

      if date_match && text_match && amount_match && merchant_match
        return saved_transaction_name
      end
    end

    false
  end

  def clean_description
    @transaction[:original_description] = @transaction[:description]
    new_description = []
    words = @transaction[:description].squeeze(' ').split #remove extra spaces between words and convert to array of words
    words.each { |word| new_description << clean_word(word) unless clean_word(word) == nil }
    @transaction[:description] = new_description
  end

  def clean_word(word)
    if state_abreviation?(word)
      @transaction[:state] = word.upcase
      return nil
    end

    if usa?(word)
      @transaction[:country] = word.upcase
      return nil
    end

    if squar?(word)
      return 'Square'
    end

    word.capitalize
  end

  def squar?(word)
    word.downcase == 'squar'
  end

  def state_abreviation?(word)
    word = word.upcase
    state_abreviations = %w(AK AL AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY)
    state_abreviations.each do |state|
      if word == state
        return true
      end
    end
    false
  end

  def saved_city?(word)
    SavedCities.each do |saved_city|

    end
  end

  def usa?(word)
    if word.upcase == 'USA'
      return true
    end
    false
  end

  def remove_merchant_from_description
    if @transaction[:merchant] == nil
      return
    end
    merchant = []
    merchant << @transaction[:merchant]
    @transaction[:description] = @transaction[:description] - merchant
  end

  def remove_empty_description
    if @transaction[:description].empty?
      @transaction.delete(:description)
      puts @transaction
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

  def set_amount_type
    if @transaction[:debit] == nil
      @transaction[:amount_type] = 'credit'
    elsif @transaction[:credit] == nil
      @transaction[:amount_type] = 'debit'
    else
      Raise(RuntimeError, 'The transaction did not have an associated debit or credit')
    end
  end

  def remove_commas(potential_string)
    if potential_string.is_a?(String)
      potential_string.delete!(',')
    end
    potential_string
  end

end



# input_file.make_pretty
# input_file.scrape_descriptions
# input_file.puts_data
# # input_file.replace_mapped_transactions
# input_file.categorize_transactions
# output_file = input_file
# output_file.export
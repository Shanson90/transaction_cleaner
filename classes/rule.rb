require_relative '../modules/db_interface'

class Rule
  TABLE_NAME = 'rules'
  MAX_FIELDS = 3

  def initialize
    @db = DBInterface.new
  end

  def add(match_pattern, fields_and_values) # match_pattern is regExp. and fields & values is a hash
    num = 1
    row = {
        'match_pattern' => match_pattern.to_s
    }
    fields_and_values.each_pair do |field, value|
      row["field#{num}"] = field.to_s
      row["value#{num}"] = value.to_s
      num += 1
    end
    if num > MAX_FIELDS
      raise(ArgumentError, "Currently only #{MAX_FIELDS} fields are supported.")
    end
    @db.add_row(TABLE_NAME, row)
  end

  def get_all_rules
    raw_rows = @db.get_all_rows(TABLE_NAME)
    raw_rows.map! do |row|
      rule = {
                :match_pattern => Regexp.new(row[0]),
                row[1].to_sym => row[2]
      }
      rule.store(row[3].to_sym, row[4]) unless row[3].nil? || row[4].nil?
      rule.store(row[5].to_sym, row[6]) unless row[5].nil? || row[6].nil?
      rule
    end
  end

end
require_relative 'db_interface'

class Rule
  TABLE_NAME = 'rules'
  MAX_FIELDS = 3

  def initialize
    @db = DBInterface.new
  end

  def add(match_pattern, rule_type, fields_and_values) # match_pattern is regExp. and fields & values is a hash
    num = 1
    row = {
        'match_pattern' => match_pattern.to_s
    }
    fields_and_values.each_pair do |field, value|
      row["field#{num}"] = field.to_s
      row["value#{num}"] = value.to_s
      num += 1
    end
    if num - 1 > MAX_FIELDS
      raise(ArgumentError, "Currently only #{MAX_FIELDS} fields are supported.")
    end
    row['type'] = rule_type.to_s
    @db.add_row(TABLE_NAME, row)
  end

  def get_all_rules
    raw_rows = @db.get_all_rows(TABLE_NAME)
    map_rules_from_db(raw_rows)
  end

  def get_rules_by_type(type)
    raw_rows = @db.get_rows(TABLE_NAME, 'type', type.to_s)
    map_rules_from_db(raw_rows)
  end

  private

  def map_rules_from_db(raw_rows)
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
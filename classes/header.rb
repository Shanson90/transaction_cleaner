require_relative 'db_interface'

class Header
  TABLE_NAME = 'headers'

  def initialize
    @db = DBInterface.new
  end

  def add(match_pattern, header) # match_pattern is regExp. header is string
    row = {
        'match_pattern' => match_pattern.to_s,
        'new_header' => header.to_s
    }
    @db.add_row(TABLE_NAME, row)
  end

  def get_all
    raw_rows = @db.get_all_rows(TABLE_NAME)
    raw_rows.map! do |row|
      {
          :match_pattern => Regexp.new(row[0]),
          :new_header => row[1].to_sym
      }
    end
  end

end
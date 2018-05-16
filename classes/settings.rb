require_relative 'db_interface'

class Settings

  TABLE ||= 'settings'

  attr_reader :date, :input_file, :output_file

  def initialize
    @data_base = DBInterface.new
    get_from_db
  end

  def get_from_db
    raw_settings = @data_base.get_top_row_with_col_names('settings')
    map_settings(raw_settings)
  end

  def set_date(date)
    @date = date
    save('date', date)
  end

  def set_input_file(path)
    @input_file = path
    save('input_file_path', path)
  end

  def set_output_file(path)
    @output_file = path
    save('output_file_path', path)
  end

  def save(column, value)
    @data_base.edit_field(TABLE, column, value, 'index_num', 1)
  end

  def map_settings(db_row)
    @date = Date.parse(db_row[:date])
    @input_file = db_row[:input_file_path]
    @output_file = db_row[:output_file_path]
  end

end
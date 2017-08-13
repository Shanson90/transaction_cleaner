require 'sqlite3'
require_relative '../environment'

class DBInterface

  def initialize
    @db = SQLite3::Database.new( DATABASE_FILE)
  end

  def add_row(table_name, columns_and_values) # insert row
    columns = ''
    values = []
    value_count = ''
    columns_and_values.each_pair do |col, val|
      columns += "#{col}, "
      values << val.to_s
      value_count += '?, '
    end
    columns.chomp! ', '
    value_count.chomp! ', '
    @db.execute("INSERT INTO #{table_name} (#{columns}) VALUES (#{value_count})", values)
  end

  def get_all_rows(table_name)
    @db.execute( "select * from #{table_name}" )
  end
end

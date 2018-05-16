require 'sqlite3'
require_relative '../environment'

class DBInterface

  def initialize
    @db = SQLite3::Database.new(DATABASE_FILE)
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

  def edit_field(table_name, column, value, search_col, search_val)
    sql = "UPDATE #{table_name} SET #{column} = '#{value}' WHERE #{search_col} = #{search_val}"
    @db.execute(sql)
  end

  def get_all_rows(table_name)
    @db.execute( "select * from #{table_name}" )
  end

  def get_rows(table, column, value)
    @db.execute( "select * from #{table} where #{column} = '#{value}'" )
  end

  def get_top_row_with_col_names(table)
    sql = "SELECT * FROM #{table} LIMIT 1"
    column_names = @db.prepare(sql).columns
    data = @db.execute(sql)[0]
    return_hash = {}

    column_names.each_with_index {| name, index | return_hash[name.to_sym] = data[index]}
    return_hash
  end
end

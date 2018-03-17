require 'csv'

class CsvOutput

  def initialize(file_name, data)
    @name = "#{file_name}.csv"
    @data = data
  end

  def create_csv
    require 'csv'
    keys = @data.flat_map(&:keys).uniq
    CSV.open(@name, 'wb') do |csv|
      csv << keys
      @data.each do |hash|
        csv << hash.values_at(*keys)
      end
    end
  end
end
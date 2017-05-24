

require 'csv'


class CsvOutput

  def initialize(file_name, )

  CSV.open('myfile.csv', 'w') do |csv|
    csv << ["row", "of", "CSV", "data"]
    csv << ["another", "row"]
    # ...
  end
end
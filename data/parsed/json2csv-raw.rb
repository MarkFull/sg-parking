require 'csv'
require 'json'
require "set"

json = JSON.parse(File.open(ARGV[0]).read)["features"]
# Pass 1: Collect headings
headings = SortedSet.new
json.each do |hash|
  headings.merge(hash['geometry'].keys)
  headings.merge(hash['properties'].keys)
end

# Pass 2: Fill data into the headings
csv_string = CSV.open(ARGV[1], "wb") do |csv|
  csv << headings
  json.each do |hash|
    row = {}
    headings.each do |heading|
      row[heading] = nil
    end
    hash['geometry'].each do |k,v|
      row[k] = v.to_s.gsub(/\r\n?/, "").delete("\n").delete("\r")
    end
    hash['properties'].each do |k,v|
      row[k] = v.to_s.gsub(/\r\n?/, "").delete("\n").delete("\r")
    end
    csv << row.values
  end
end
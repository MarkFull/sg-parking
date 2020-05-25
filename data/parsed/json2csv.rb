require 'csv'
require 'json'
require "set"

json = JSON.parse(File.open(ARGV[0]).read)["features"]
# Pass 1: Collect headings
headings = [
  'geometry',
  'price',
  'id',
  'name',
  'source',
  'source_updated_at',
  'updated_at',
  
  'address',
  'has_free',
  'free_time',
  'grace_period',
  'basement',
  'decks',
  'building_type',
  'gantry_height',
  'night_parking',
  'short_term_parking',
  'payment_method',
  'raw'
]


# Pass 2: Fill data into the headings
csv_string = CSV.open(ARGV[1], "wb") do |csv|
  csv << headings
  json.each do |hash|
    properties = hash['properties']
    row = {}
    row['geometry'] = hash['geometry']

    # HDB
    if properties['car_park_basement'] != nil
      row['price'] = ''
      row['id'] = properties['car_park_no']
      row['name'] = properties['address']
      row['source'] = 'HDB'
      row['source_updated_at'] = Date.new(2019,4,9)
      row['updated_at'] = DateTime.new(2019,4,9)
  
      row['address'] = properties['address']
      row['has_free'] = properties['free_parking'] != 'NO'
      row['free_time'] = properties['free_parking']
      row['grace_period'] = ''
      row['basement'] = properties['car_park_basement']
      row['decks'] = properties['car_park_decks']
      row['building_type'] = properties['car_park_type']
      row['gantry_height'] = properties['gantry_height']
      row['night_parking'] = properties['night_parking']
      row['short_term_parking'] = properties['short_term_parking']
      row['payment_method'] = properties['type_of_parking_system']
  
      row['raw'] = properties

    elsif properties['ppCode'] != nil
      row['price'] = properties['schedules']
      row['id'] = properties['ppCode']
      row['name'] = properties['ppName']
      row['source'] = 'URA'
      row['source_updated_at'] = Date.new(2019,4,9)
      row['updated_at'] = DateTime.new(2019,4,9)
  
      row['address'] = properties['ppName']
      row['has_free'] = properties['free_parking'] != nil
      row['free_time'] = properties['free_parking']
      row['grace_period'] = ''
      row['basement'] = ''
      row['decks'] = ''
      row['building_type'] = ''
      row['gantry_height'] = ''
      row['night_parking'] = ''
      row['short_term_parking'] = ''
      row['payment_method'] = properties['parkingSystem']
  
      row['raw'] = properties

    elsif properties['WeekDays_Rate_1'] != nil
      row['price'] = {
        WeekDays_Rate_1: properties['WeekDays_Rate_1'],
        WeekDays_Rate_2: properties['WeekDays_Rate_2'],
        Saturday_Rate: properties['Saturday_Rate'],
        Sunday_PublicHoliday_Rate: properties['Sunday_PublicHoliday_Rate']
      }
      row['id'] = properties['CarPark']
      row['name'] = properties['CarPark']
      row['source'] = 'LTA'
      row['source_updated_at'] = Date.new(2018,11,14)
      row['updated_at'] = DateTime.new(2018,11,14)
  
      row['address'] = properties['ppName']
      row['has_free'] = properties['free_parking'] != nil
      row['free_time'] = properties['free_parking']
      row['grace_period'] = ''
      row['basement'] = ''
      row['decks'] = ''
      row['building_type'] = ''
      row['gantry_height'] = ''
      row['night_parking'] = ''
      row['short_term_parking'] = ''
      row['payment_method'] = ''

      row['raw'] = properties
    else
      row['price'] = properties['rate']
      row['id'] = properties['name']
      row['name'] = properties['name']
      row['source'] = properties['source']
      row['source_updated_at'] = Date.today
      row['updated_at'] = DateTime.now
  
      row['address'] = properties['name']
      row['has_free'] = properties['free_parking'] != 'NO'
      row['free_time'] = properties['free_parking']
      row['grace_period'] = ''
      row['basement'] = ''
      row['decks'] = ''
      row['building_type'] = ''
      row['gantry_height'] = ''
      row['night_parking'] = ''
      row['short_term_parking'] = ''
      row['payment_method'] = ''

      row['raw'] = properties
    end
    csv << row.values
  end
end
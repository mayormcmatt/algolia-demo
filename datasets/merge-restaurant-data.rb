require 'json'
require 'csv'

raw_json = File.read('restaurants_list.json')
parsed_json = JSON.parse(raw_json)

raw_csv = CSV.table('restaurants_info.csv', header_converters: nil, col_sep: ';')
csv_to_hash = raw_csv.map {|row| row.to_hash}

# Make file to place merged data into, enable write
merged_data = File.open('merged.json', 'w')

# Duplicate JSON so as not to pollute original; this will be merged output, too
merge = parsed_json.dup
ref_hash = {}
# Write to new hash from hashed CSV file referencing objectID
csv_to_hash.each { |hash| ref_hash[hash['objectID']] = hash }

# Magic time; find objectID key, merge hash
merge.each do |hash|
	obj_ID = hash['objectID']
	hash2 = ref_hash[obj_ID]
	if hash2
		hash2.each_pair do |k, v|
			next if 'objectID' == k
			hash[k] = v
		end
	end
end

# Cleanup merged output
make_merged_json = merge.to_json

# Write merged JSON to file
merged_data.puts make_merged_json
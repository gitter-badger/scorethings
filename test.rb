require 'wikidata'

search = Wikidata::Item.search 'Patton Oswalt'

search.each do |item|
  puts item.label
end

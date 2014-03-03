# create Centre
%w(AM AN CF CN DJ GR LL LM LP LY MA MP PA PO RN SE ST TG TO).each do |code|
  Centre.find_or_create_by!(code: code, name: code)
end

# create Motif
puts "importing Motifs table from csv"
CSV.foreach("csv/motifs.csv", headers: true) do |row|
  puts "processing row##{row['ncodemotif']}"
  Motif.find_or_create_by!(oldid: row['ncodemotif'], name: row['code'])
end

# create Categoriesp
# csv processing : add "NSP" in first row
puts "importing Categoriesps table from csv"
CSV.foreach("csv/categoriesps.csv", headers: true) do |row|
  puts "processing row##{row['ncategorie']}"
  Categoriesp.find_or_create_by!(oldid: row['ncategorie'], name: row['libelle'])
end

# create ExpoType
puts "importing ExpoType table from csv"
CSV.foreach("csv/expo_types.csv", headers: true) do |row|
  puts "processing row##{row['ntype']}"
  ExpoType.find_or_create_by!(oldid: row['ntype'], name: row['libelle'])
end

# create ExpoNature
puts "importing ExpoNature table from csv"
CSV.foreach("csv/expo_natures.csv", headers: true) do |row|
  puts "processing row##{row['nnatexpo']}"
  ExpoNature.find_or_create_by!(oldid: row['nnatexpo'], name: row['libelle'])
end

# create ExpoTerme
puts "importing ExpoTerme table from csv"
CSV.foreach("csv/expo_termes.csv", headers: true) do |row|
  puts "processing row##{row['nterme']}"
  ExpoTerme.find_or_create_by!(oldid: row['nterme'], name: row['libelle'])
end

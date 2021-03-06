# create Indication
puts 'importing Indication table from csv'
CSV.foreach('csv/indications.csv', headers: true) do |row|
  puts "processing row##{row['nindication']}"
  Indication.find_or_create_by!(oldid: row['nindication'], name: row['libelle'])
end

# create Dci
puts 'importing Dci table from csv'
CSV.foreach('csv/dcis.csv', headers: true) do |row|
  puts "processing row##{row['ndci']}"
  Dci.find_or_create_by!(oldid: row['ndci'], libelle: row['libelle'])
end

# create Produit
puts 'importing Produit table from csv'
CSV.foreach('csv/produits.csv', headers: true) do |row|
  puts "processing row##{row['nproduit']}"
  Produit.find_or_create_by!(oldid: row['nproduit'], name: row['libelle'])
end

# create Atc
puts 'Importing atcs from csv'
CSV.foreach('csv/atcs.csv', headers: true) do |row|
  oldid = row['natc']
  puts "processing row##{oldid}"
  Atc.find_or_create_by!(oldid: oldid,
                         codeterme: row['codeTerme'],
                         codetermepere: row['codeTermePere'],
                         libabr: row['libAbr'],
                         level: row['Level'],
                         libelle: row['libelle']
                        )
end

puts 'Filling up atc parent_id using codeterme and codetermepere'
Atc.all.each do |atc|
  pere = Atc.where(codeterme: atc.codetermepere).first
  atc.update_attribute(:parent_id, pere.id) unless pere.nil?
end

# populate Atc/Produit join table
puts 'Importing Classification table from csv'
Classification.destroy_all
CSV.foreach('csv/classifications.csv', headers: true) do |row|
  classification = Classification.new
  classification.produit = Produit.where(oldid: row['nproduit']).first
  classification.atc = Atc.where(oldid: row['natc']).first
  classification.save!
end

# populate Dci/Produit join table
puts 'Importing Composition table from csv'
Composition.destroy_all
CSV.foreach('csv/compositions.csv', headers: true) do |row|
  compo = Composition.new
  compo.produit = Produit.where(oldid: row['nproduit']).first
  compo.dci = Dci.where(oldid: row['ndci']).first
  compo.save!
end

# create Indication
puts "importing Indication table from csv"
CSV.foreach("csv/indications.csv", headers: true) do |row|
  puts "processing row##{row['nindication']}"
  Indication.find_or_create_by!(oldid: row['nindication'], name: row['libelle'])
end

# create Dcis
puts "importing Dci table from csv"
CSV.foreach("csv/dcis.csv", headers: true) do |row|
  puts "processing row##{row['ndci']}"
  Dci.find_or_create_by!(oldid: row['ndci'], libelle: row['libelle'])
end

# create Produits
puts "importing Produit table from csv"
CSV.foreach("csv/produits.csv", headers: true) do |row|
  puts "processing row##{row['nproduit']}"
  Produit.find_or_create_by!(oldid: row['nproduit'], name: row['libelle'])
end

puts "Importing atcs from csv"
CSV.foreach("csv/atcs.csv", headers: true) do |row|
  oldid = row["natc"]
  puts "processing row##{oldid}"
  Atc.find_or_create_by!(oldid: oldid,
    codeterme: row['codeTerme'],
    codetermepere: row['codeTermePere'],
    libabr: row['libAbr'],
    level: row['Level'],
    libelle: row['libelle']
)
end

puts "Filling up atc parent_id using codeterme and codetermepere"
Atc.all.each do |atc|
  pere = Atc.where(codeterme: atc.codetermepere).first
  unless pere.nil?
    atc.update_attribute(:parent_id, pere.id)
  end
end

# populate Atc/Produit join table
puts "Importing Classification table from csv"
CSV.foreach("csv/classifications.csv", headers: true) do |row|
  Classification.destroy_all
  classification = Classification.create
  classification.produit = Produit.where(oldid: row['nproduit']).first
  classification.atc = Atc.where(oldid: row['natc']).first
end

# populate Dci/Produit join table
puts "Importing Composition table from csv"
CSV.foreach("csv/compositions.csv", headers: true) do |row|
  Composition.destroy_all
  compo = Composition.create
  compo.produit = Produit.where(oldid: row['nproduit']).first
  compo.dci = Dci.where(oldid: row['ndci']).first
end

# create Expositions
puts "importing Exposition table from csv"
CSV.foreach("csv/expositions.csv", headers: true) do |row|
  oldid = row['nexposition']
  puts "processing expo row##{oldid}"
  expo = Exposition.find_or_initialize_by(oldid: oldid,
                                expo_type_id: row['ntype'],
                                expo_terme_id: row['nterme'],
                                expo_nature_id: row['nnatexpo'],
                                numord: row['numord'],
                                duree: row['duree'],
                                duree2: row['duree2'],
                                dose: row['dose'],
                                de: row['de'],
                                a: row['a'],
                                de2: row['de2'],
                                a2: row['a2'],
                                medpres: row['medpres']
                               )
  expo.produit = Produit.where(oldid: row['nproduit']).first
  expo.indication = Indication.where(oldid: row['nindication']).first
  expo.dossier = Dossier.where(code: row['nappelsaisi']).first
  expo.save
end

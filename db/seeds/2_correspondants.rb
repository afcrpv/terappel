# create Formule
puts "importing Formule table from csv"
CSV.foreach("csv/formules.csv", headers: true) do |row|
  puts "processing row##{row['nformule']}"
  Formule.find_or_create_by!(oldid: row['nformule'], name: row['libelle'])
end

# create Qualite
puts "importing Qualite table from csv"
CSV.foreach("csv/qualites.csv", headers: true) do |row|
  puts "processing row##{row['nqualite']}"
  Qualite.find_or_create_by!(oldid: row['nqualite'], name: row['libelle'])
end

# create Specialite
puts "importing Specialite table from csv"
CSV.foreach("csv/specialites.csv", headers: true) do |row|
  puts "processing row##{row['nspecialite']}"
  Specialite.find_or_create_by!(oldid: row['nspecialite'], name: row['libelle'])
end

# create Demandeur/Relance for dossiers
#dossier.demandeur = Demandeur.find_or_create_by!(correspondant_id: row['nappelsaisi'][0..1]+row['nident'])
#dossier.relance = Relance.find_or_create_by!(correspondant_id: row['nappelsaisi'][0..1]+row['nrelance'])

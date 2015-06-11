# create Expositions
# csv processing : move lines with 2nd column empty to the top for analysis
# :g/^\d\{7},,/m0
puts "importing Exposition table from csv"
CSV.foreach("csv/expositions.csv", headers: true) do |row|
  oldid = row['nexposition']
  puts "processing expo row##{oldid}"
  expo = Exposition.find_or_initialize_by(oldid: oldid)
  expo.expo_type_id = row['ntype']
  expo.expo_terme_id = row['nterme']
  expo.expo_nature_id = row['nnatexpo']
  expo.numord = row['numord']
  expo.duree = row['duree']
  expo.duree2 = row['duree2']
  expo.dose = row['dose']
  expo.de = row['de']
  expo.a = row['a']
  expo.de2 = row['de2']
  expo.a2 = row['a2']
  expo.medpres = row['medpres']
  expo.produit = Produit.where(oldid: row['nproduit']).first
  expo.indication = Indication.where(oldid: row['nindication']).first
  expo.nappelsaisi = row['nappelsaisi']
  expo.dossier = Dossier.where(code: row['nappelsaisi']).first
  expo.save! if expo.produit
end

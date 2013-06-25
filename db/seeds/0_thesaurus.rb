# create Centre
#crpvs = Psych.load( <<EOY )
#- name: Amiens
  #departements:
    #- "02"
    #- "60"
    #- "80"
#- name: Angers
  #departements:
    #- "49"
    #- "53"
    #- "72"
#- name: Besançon
  #departements:
    #- "25"
    #- "39"
    #- "70"
    #- "90"
#- name: Bordeaux
  #departements:
    #- "24"
    #- "33"
    #- "40"
    #- "47"
    #- "64"
    #- "971"
    #- "972"
    #- "973"
    #- "974"
    #- "976"
#- name: Brest
  #departements:
    #- "29"
    #- "56"
#- name: Caen
  #departements:
    #- "14"
    #- "50"
    #- "61"
#- name: Clermont-Ferrand
  #departements:
    #- "03"
    #- "15"
    #- "43"
    #- "63"
#- name: Créteil
  #departements:
    #- "77"
    #- "94"
#- name: Dijon
  #departements:
    #- "21"
    #- "58"
    #- "71"
    #- "89"
#- name: Grenoble
  #departements:
    #- "38"
#- name: Lille
  #departements:
    #- "59"
    #- "62"
#- name: Limoges
  #departements:
    #- "19"
    #- "23"
    #- "36"
    #- "87"
#- name: Lyon
  #departements:
    #- "01"
    #- "07"
    #- "26"
    #- "69"
    #- "73"
    #- "74"
#- name: Marseille
  #departements:
    #- "04"
    #- "13"
    #- "84"
    #- "2A"
    #- "2B"
#- name: Montpellier
  #departements:
    #- "11"
    #- "30"
    #- "34"
    #- "48"
    #- "66"
#- name: Nancy
  #departements:
    #- "54"
    #- "55"
    #- "57"
    #- "88"
#- name: Nantes
  #departements:
    #- "44"
    #- "85"
#- name: Nice
  #departements:
    #- "06"
    #- "05"
    #- "83"
#- name: Paris-Pitié-Salpêtrière
  #departements:
    #- "28"
  #arrondissements:
    #- 5
    #- 8
    #- 13
#- name: Paris-Georges Pompidou
  #departements:
    #- "92"
  #arrondissements:
    #- 1
    #- 14
    #- 15
    #- 16
#- name: Paris-Saint-Antoine
  #departements:
    #- "93"
  #arrondissements:
    #- 3
    #- 4
    #- 11
    #- 12
    #- 20
#- name: Paris-Cochin-St Vincent de Paul
  #departements:
    #- "91"
  #arrondissements:
    #- 6
    #- 7
#- name: Paris-Fernand Widal
  #departements:
    #- "78"
    #- "95"
  #arrondissements:
    #- 2
    #- 9
    #- 10
    #- 17
    #- 18
    #- 19
#- name: Poitiers
  #departements:
    #- "16"
    #- "17"
    #- "79"
    #- "86"
#- name: Reims
  #departements:
    #- "8"
    #- "10"
    #- "51"
    #- "52"
#- name: Rennes
  #departements:
    #- "22"
    #- "35"
#- name: Rouen
  #departements:
    #- "27"
    #- "76"
#- name: Saint-Etienne
  #departements:
    #- "42"
#- name: Strasbourg
  #departements:
    #- "67"
    #- "68"
#- name: Toulouse
  #departements:
    #- "09"
    #- "12"
    #- "31"
    #- "32"
    #- "46"
    #- "65"
    #- "81"
    #- "82"
#- name: Tours
  #departements:
    #- "18"
    #- "37"
    #- "41"
    #- "45"
#EOY

#Centre.find_or_create_by!(code: "LY", name: "Lyon")

# create Motif
puts "importing Motifs table from csv"
CSV.foreach("csv/motifs.csv", headers: true) do |row|
  puts "processing row##{row['ncodemotif']}"
  Motif.find_or_create_by!(oldid: row['ncodemotif'], name: row['code'])
end

# create Categoriesp
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

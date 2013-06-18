# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

require 'csv'

puts "creating first Centre"
Centre.where(name: "Lyon").find_or_create_by!(code: "LY")

# create Motif
puts "importing Motifs table from csv"
CSV.foreach("csv/motifs.csv", headers: true) do |row|
  Motif.find_or_create_by!(oldid: row['ncodemotif'], name: row['code'])
end

# create Categoriesp
puts "importing Categoriesps table from csv"
CSV.foreach("csv/categoriesps.csv", headers: true) do |row|
  Categoriesp.find_or_create_by!(oldid: row['ncategorie'], name: row['libelle'])
end

# create ExpoType
puts "importing ExpoType table from csv"
CSV.foreach("csv/expo_types.csv", headers: true) do |row|
  ExpoType.find_or_create_by!(oldid: row['ntype'], name: row['libelle'])
end

# create ExpoNature
puts "importing ExpoNature table from csv"
CSV.foreach("csv/expo_natures.csv", headers: true) do |row|
  ExpoNature.find_or_create_by!(oldid: row['nnatexpo'], name: row['libelle'])
end

# create ExpoTerme
puts "importing ExpoTerme table from csv"
CSV.foreach("csv/expo_termes.csv", headers: true) do |row|
  ExpoTerme.find_or_create_by!(oldid: row['nterme'], name: row['libelle'])
end

# create Indication
puts "importing Indication table from csv"
CSV.foreach("csv/indications.csv", headers: true) do |row|
  Indication.find_or_create_by!(oldid: row['nindication'], name: row['libelle'])
end

# create Formule
puts "importing Formule table from csv"
CSV.foreach("csv/formules.csv", headers: true) do |row|
  Formule.find_or_create_by!(oldid: row['nformule'], name: row['libelle'])
end

# create Qualite
puts "importing Qualite table from csv"
CSV.foreach("csv/qualites.csv", headers: true) do |row|
  Qualite.find_or_create_by!(oldid: row['nqualite'], name: row['libelle'])
end

# create Specialite
puts "importing Specialite table from csv"
CSV.foreach("csv/specialites.csv", headers: true) do |row|
  Specialite.find_or_create_by!(oldid: row['nspecialite'], name: row['libelle'])
end

# create Produits
puts "importing Produit table from csv"
CSV.foreach("csv/produits.csv", headers: true) do |row|
  Produit.find_or_create_by!(oldid: row['nproduit'], name: row['libelle'])
end

# create Dossiers
puts "importing Dossier table from csv"
CSV.foreach("csv/dossiers.csv", headers: true) do |row|
  dossier = Dossier.find_or_create_by!(code: row['nappelsaisi'],
    evolution: row['ntypaccou'],
    categoriesp_id: row['ncategorie'],
    motif_id: row['ncode'],
    date_appel: row['da'],
    date_dernieres_regles: row['ddr'],
    date_reelle_accouchement: row['dra'],
    date_accouchement_prevu: row['dap'],
    date_debut_grossesse: row['dg'],
    name: row['nom'],
    prenom: row['prenom'],
    age: row['age'],
    antecedents_perso: Dossier::ONI[row['ap'].to_i],
    antecedents_fam: Dossier::ONI[row['af'].to_i],
    a_relancer: row['relance'],
    ass_med_proc: row['assmedproc'],
    expo_terato: row['expoterato'],
    fcs: row['fcs'],
    geu: row['geu'],
    miu: row['miu'],
    ivg: row['ivg'],
    img: row['img'],
    nai: row['naissance'],
    terme: row['terme'],
    grsant: row['nbgroanter'],
    modaccouch: Dossier::MODACCOUCH[row['modaccouch'].to_i],
    tabac: Dossier::TABAC[row['tabac'].to_i],
    alcool: Dossier::ALCOOL[row['alcool'].to_i],
    age_grossesse: row['agegrosse'],
    comm_antecedents_perso: row['atcdpersonnels'],
    comm_antecedents_fam: row['atcdfamiliaux'],
    commentaire: [row['comevol'], row['comexpo'], row['combebe'], row['comgene']].join("\n"),
    path_mat: row['pathomater'],
    relance_counter: row['nbrRelance']
  )
  dossier.demandeur = Demandeur.find_or_create_by!(correspondant_id: row['nident'])
  dossier.relance = Relance.find_or_create_by!(correspondant_id: row['nrelance'])
end

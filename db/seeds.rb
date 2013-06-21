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

# create Indication
puts "importing Indication table from csv"
CSV.foreach("csv/indications.csv", headers: true) do |row|
  puts "processing row##{row['nindication']}"
  Indication.find_or_create_by!(oldid: row['nindication'], name: row['libelle'])
end

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

# create Dcis
puts "importing Dci table from csv"
CSV.foreach("csv/dcis.csv", headers: true) do |row|
  puts "processing row##{row['ndci']}"
  Dci.find_or_create_by!(oldid: row['ndci'], name: row['libelle'])
end

# create Produits
puts "importing Produit table from csv"
CSV.foreach("csv/produits.csv", headers: true) do |row|
  puts "processing row##{row['nproduit']}"
  Produit.find_or_create_by!(oldid: row['nproduit'], name: row['libelle'])
end

klass = name.classify.constantize

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
collection = Atc.all
collection.each do |item|
  pere = Atc.where(codeterme: item.codetermepere)
  unless pere.nil?
    item.update_attribute(parent_id: pere.id)
  end
end

#puts "Importing classifications table from csv"
#CSV.foreach("csv/bebes_#{name.pluralize}.csv", headers: true) do |row|
  #oldid = row['nappelsaisi'][0..1]+row['nbebe'].to_s
  #puts "processing row##{oldid}"
  #bebe = Bebe.where(oldid: oldid)
  #bebe.send(:"#{name.pluralize}") << klass.where(oldid: row["n#{name}"])
#end

# populate Dci/Produit join table
puts "Importing Composition table from csv"
CSV.foreach("csv/compositions.csv", headers: true) do |row|
  Composition.destroy_all
  compo = Composition.create
  compo.produit = Produit.where(oldid: row['nproduit'])
  compo.dci = Dci.where(oldid: row['ndci'])
end


# create Dossiers
puts "importing Dossier table from csv"
CSV.foreach("csv/dossiers.csv", headers: true) do |row|
  puts "processing row##{row['nappelsaisi']}"
  dossier = Dossier.find_or_create_by!(code: row['nappelsaisi'],
    evolution: Dossier::EVOLUTION[row['ntypaccou'].to_i + 1],
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
  dossier.demandeur = Demandeur.find_or_create_by!(correspondant_id: row['nappelsaisi'][0..1]+row['nident'])
  dossier.relance = Relance.find_or_create_by!(correspondant_id: row['nappelsaisi'][0..1]+row['nrelance'])
end

# create Expositions
puts "importing Exposition table from csv"
CSV.foreach("csv/expositions.csv", headers: true) do |row|
  oldid = row['nexposition']
  puts "processing row##{oldid}"
  Exposition.find_or_create_by!(oldid: oldid,
                                produit_id: row['nproduit'],
                                dossier_id: row['nappelsaisi'],
                                expo_type_id: row['ntype'],
                                indication_id: row['nindication'],
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
end

# create Bebes
puts "importing Bebe table from csv"
CSV.foreach("csv/bebes.csv", headers: true) do |row|
  oldid =  row['nappelsaisi'][0..1]+row['nbebe'].to_s
  puts "processing row##{oldid}"
  bebe = Bebe.find_or_create_by!(oldid: oldid,
                          dossier_id: Dossier.where(code: row['nappelsaisi']),
                          malformation: row['malforma'],
                          pathologie: row['patho'],
                          sexe: row['sexe'],
                          poids: row['poids'],
                          apgar1: row['apgar'],
                          apgar5: row['apgar2'],
                          pc: row['pc'],
                          taille: row['taille']
                         )
end

%w(malformation pathologie).each do |name|
  klass = name.classify.constantize

  puts "Importing #{name.pluralize} from csv"
  CSV.foreach("csv/#{name.pluralize}.csv", headers: true) do |row|
    oldid = row["n#{name}"]
    puts "processing row##{oldid}"
    klass.find_or_create_by!(oldid: oldid,
      codeterme: row['CodeTerme'],
      codetermepere: row['CodeTermePere'],
      libabr: row['libabr'],
      level: row['level'],
      libelle: row['libelle']
  )
  end

  puts "Filling up parent_id using codeterme and codetermepere"
  collection = klass.all
  collection.each do |item|
    pere = klass.where(codeterme: item.codetermepere)
    unless pere.nil?
      item.parent_id = pere.id
      item.save!
    end
  end

  puts "Importing Bebe #{name.pluralize}"
  CSV.foreach("csv/bebes_#{name.pluralize}.csv", headers: true) do |row|
    oldid = row['nappelsaisi'][0..1]+row['nbebe'].to_s
    puts "processing row##{oldid}"
    bebe = Bebe.where(oldid: oldid)
    bebe.send(:"#{name.pluralize}") << klass.where(oldid: row["n#{name}"])
  end
end

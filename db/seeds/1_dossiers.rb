# create Dossiers
puts "importing Dossier table from csv"
CSV.foreach("csv/dossiers.csv", headers: true) do |row|
  puts "processing dossier##{row['nappelsaisi']}"
  dossier = Dossier.find_or_initialize_by(code: row['nappelsaisi'])
  dossier.centre_id= Centre.where(code: row['nappelsaisi'][0..1]).first.id
  dossier.evolution= Dossier::EVOLUTION[row['ntypaccou'].to_i + 1]
  dossier.categoriesp_id= row['ncategorie']
  dossier.motif_id= row['ncode']
  dossier.date_appel= row['da']
  dossier.date_dernieres_regles= row['ddr']
  dossier.date_reelle_accouchement= row['dra']
  dossier.date_accouchement_prevu= row['dap']
  dossier.date_debut_grossesse= row['dg']
  dossier.name= row['nom']
  dossier.prenom= row['prenom']
  dossier.age= row['age']
  dossier.antecedents_perso= Dossier::ONI[row['ap'].to_i]
  dossier.antecedents_fam= Dossier::ONI[row['af'].to_i]
  dossier.a_relancer= row['relance']
  dossier.ass_med_proc= row['assmedproc']
  dossier.expo_terato= row['expoterato']
  dossier.fcs= row['fcs']
  dossier.geu= row['geu']
  dossier.miu= row['miu']
  dossier.ivg= row['ivg']
  dossier.img= row['img']
  dossier.nai= row['naissance']
  dossier.terme= row['terme']
  dossier.grsant= row['nbgroanter']
  dossier.modaccouch= Dossier::MODACCOUCH[row['modaccouch'].to_i]
  dossier.tabac= Dossier::TABAC[row['tabac'].to_i]
  dossier.alcool= Dossier::ALCOOL[row['alcool'].to_i]
  dossier.age_grossesse= row['agegrosse']
  dossier.comm_antecedents_perso= row['atcdpersonnels']
  dossier.comm_antecedents_fam= row['atcdfamiliaux']
  dossier.commentaire= [row['comevol'], row['comexpo'], row['combebe'], row['comgene']].join("\n")
  dossier.path_mat= row['pathomater']
  dossier.relance_counter= row['nbrRelance']
  dossier.nident= row['nident']
  dossier.nrelance= row['nrelance']
  dossier.save
  if dossier.valid?
    puts "OK! dossier##{row['nappelsaisi']} created"
  else
    puts "NOK! dossier##{row['nappelsaisi']} invalid\n#{dossier.errors.inspect}"
    break
  end
end

# create Dossiers
puts "importing Dossier table from csv"
CSV.foreach("csv/dossiers.csv", headers: true) do |row|
  dossier = Dossier.find_or_initialize_by(code: row['nappelsaisi'])
  unless dossier.new_record?
    puts "creating dossier##{row['nappelsaisi']}"
    dossier.attributes.merge({
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
      relance_counter: row['nbrRelance'],
      nident: row['nident'],
      nrelance: row['nrelance']
    })
    dossier.save(validate: false)
  end
end

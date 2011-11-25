class AddMorefieldsToDossiers < ActiveRecord::Migration
  def change
    change_table :dossiers do |t|
      # relations
      t.integer   :evolution_id                   #ntypaccou
      t.integer   :correspondant_id               #nident
      t.integer   :categoriesp_id                 #ncategorie
      t.integer   :motif_id                       #ncode
      t.integer   :mod_accouch_id                 #modaccouch '0', '1', '2', '3' = VBS,VBI,CES,INC
      # dates
      t.date      :date_dernieres_regles          #ddr
      t.date      :date_reelle_accouchement       #dra
      t.date      :date_accouchement_prevu        #dap
      t.date      :date_debut_grossesse           #dg

      # données patiente
      t.string    :prenom
      t.integer   :age

      # champs dictionnaire 'non, oui, nsp'
      t.string    :antecedents_perso              #ap '0', '1', '2'
      t.string    :antecedents_fam                #af '0', '1', '2'
      t.string    :ass_med_proc                   #assmedproc 0, 1, 2
      t.string    :expo_terato                    #expoterato 'O', 'N', 'I'
      t.string    :path_mat                       #pathomater '0','1','2'

      # champs dictionnaire tabac/alcool
      t.integer   :tabac                          #0,1,2,3,4
      t.integer   :alcool                         #0,1,2,3

      # champs pseudo boolean 0, 1 = 'non, oui'
      t.integer   :a_relancer                     #relance

      # champs numériques
      t.integer   :fcs, :geu, :miu, :ivg
      t.integer   :nai                            #naissance
      t.integer   :age_grossesse                  #agegrosse
      t.integer   :terme
      t.integer   :relance_counter                #nbrRelance

      # champs commentaire
      t.text      :comm_antecedents_perso         #atcdpersonnels
      t.text      :comm_antecedents_fam           #atcdfamilliaux
      t.text      :commentaire                    #comgene
      t.text      :comm_expo                      #comexpo
      t.text      :comm_evol                      #comevol
      t.text      :comm_bebe                      #combebe
    end

    fields = %w(date_appel name motif_id evolution_id correspondant_id categoriesp_id mod_accouch_id expo_terato)
    fields.each do |field|
      add_index :dossiers, field.to_sym
    end
  end
end

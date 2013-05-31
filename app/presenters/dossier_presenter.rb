#encoding: utf-8
class DossierPresenter < BasePresenter
  presents :dossier
  delegate :code, :name, :motif_code, :motif_name, :categoriesp, :a_relancer, to: :dossier

  def commentaire(parse=true)
    parse ? simple_format(dossier.commentaire) : dossier.commentaire
  end

  def date_appel
    localize_date(dossier.date_recueil)
  end

  def date_recueil_evol
    localize_date(dossier.date_recueil_evol)
  end

  def demandeur
    handle_none dossier.demandeur do
      dossier.demandeur.correspondant
    end
  end

  def relance
    handle_none dossier.relance do
      dossier.relance.correspondant
    end
  end

  def poids
    handle_none dossier.poids do
      "#{dossier.poids} kg"
    end
  end

  def taille
    handle_none dossier.taille do
      "#{dossier.taille} cm"
    end
  end

  def poids_et_taille
    [poids, taille].join("/").html_safe + imc
  end

  def imc
    if dossier.poids && dossier.taille
      " (IMC : #{(dossier.poids / (dossier.taille/100.to_f)**2).round})"
    end
  end

  (1..3).each do |i|
    define_method :"produit#{i}" do
      handle_none dossier.expositions[i-1] do
        dossier.expositions[i-1].produit
      end
    end
  end

  %w(malformation pathologie).each do |mp|
    define_method mp do
      if dossier.bebes.any?
        ["Oui", "Non", "Ne sait pas"].each do |value|
          if dossier.bebes.any? {|b| b.send(mp) == value}
            return value
          end
        end
      end
    end
  end


  %w(expo_terato ass_med_proc toxiques folique patho1t path_mat).each do |method|
    define_method method do
      handle_none dossier.send(method) do
        hash = array_to_hash Dossier::ONI
        hash[dossier.send(method)]
      end
    end
  end
  %w(modaccouch evolution).each do |method|
    define_method method do
      hash = array_to_hash(Dossier.const_get(method.upcase))
      handle_none dossier.send(method) do
        hash[dossier.send(method)]
      end
    end
  end

  %w(age_grossesse terme).each do |sa|
    define_method sa do
      handle_none dossier.send(sa) do
        dossier.send(sa).to_s + " SA"
      end
    end
  end

  def atcds_grs
    attribute = dossier.grsant
    handle_none attribute do
      if attribute == 0
        result = "primipare-primigeste"
      else
        result = attribute.to_s
        gestes = {}
        %w(fcs geu miu ivg img nai).each do |geste|
          if geste == "nai"
            gestes["naissance"] = dossier.send(geste)
          else
            gestes[geste] = dossier.send(geste)
          end
        end
        autres = []
        gestes.each do |k, v|
          if v && v > 0
            if k == "naissance"
              autres.push "#{pluralize(v, k)}"
            else
              autres.push v.to_s + " #{k.upcase}"
            end
          end
        end
        if attribute == 1
          result = autres.join
        else
          result += " (#{autres.to_sentence})"
        end
      end
    end
  end

  %w(fam perso).each do |atcds|
    define_method "atcds_#{atcds}" do
      attribute = dossier.send("antecedents_#{atcds}")
      handle_none attribute do
        case attribute
        when "1" then "Non"
        when "0" then self.send("comm_antecedents_#{atcds}")
        else
          attribute
        end
      end
    end
  end

  %w(tabac alcool).each do |vice|
    define_method vice do
      const = vice == "tabac" ? Dossier::TABAC : Dossier::ALCOOL
      suffix = vice == "tabac" ? " cigarettes/j" : ""
      hash = array_to_hash(const)
      handle_none dossier.send(vice) do
        suffix = "" if dossier.send(vice) == 0
        hash[dossier.send(vice).to_s] + suffix
      end
    end
  end

  def patiente
    dossier.patiente_fullname
  end

  def patient_data
    [age, poids_taille_imc].compact.join(", ")
  end

  def age
    value_with_unit dossier.age, "ans"
  end

  def poids
    value_with_unit dossier.poids, "kg"
  end

  def taille
    value_with_unit dossier.taille, "cm"
  end

  def imc
    dossier.imc if dossier.imc
  end

  def poids_taille_imc
    result = [poids, taille].join(" x ")
    result << " (IMC #{imc})" if imc
  end


  %w(appel dernieres_regles debut_grossesse accouchement_prevu reelle_accouchement recueil_evol).each do |date|
    method_name = "date_#{date}"
    define_method method_name do
      handle_none dossier.send(method_name) do
        localize_date dossier.send(method_name)
      end
    end
  end

  def produit_name(index)
    if dossier.produits.any?
      dossier.produits[index].try(:name)
    end
  end

  def expositions
    handle_none dossier.produits_names, "Aucune" do
      twipsy dossier.produits_names
    end
  end

  private

  def value_with_unit(value, unit)
    if value.present?
      "#{value} #{unit}"
    end
  end
end

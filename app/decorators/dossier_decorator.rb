class DossierDecorator < ApplicationDecorator
  delegate_all

  def nbr_bebes
    object.bebes.size
  end

  def commentaire(parse=true)
    parse ? h.simple_format(object.commentaire) : object.commentaire
  end

  def date_appel
    localize_date(object.date_recueil)
  end

  def date_recueil_evol
    localize_date(object.date_recueil_evol)
  end

  def demandeur
    handle_none object.demandeur do
      object.demandeur.correspondant
    end
  end

  def relance
    handle_none object.relance do
      object.relance.correspondant
    end
  end

  def poids
    handle_none object.poids do
      "#{object.poids}"
    end
  end

  def taille
    handle_none object.taille do
      "#{object.taille}"
    end
  end

  def poids_et_taille
    [poids, taille].join("/").html_safe + imc
  end

  def imc
    if object.poids && object.taille
      " (IMC : #{(object.poids / (object.taille/100.to_f)**2).round})"
    end
  end

  (1..3).each do |i|
    %w(dose de a de2 a2).each do |method|
      define_method :"#{method}_#{i}" do
        exposition = object.expositions[i-1]
        handle_none exposition do
          exposition.send(:try, :"#{method}")
        end
      end
    end
    %w(produit indication expo_terme).each do |name|
      define_method :"#{name}_#{i}" do
        exposition = object.expositions[i-1]
        handle_none exposition do
          handle_none exposition.send(:"#{name}") do
            exposition.send(:"#{name}_name")
          end
        end
      end
    end
  end

  %w(sexe pc apgar1 apgar5).each do |name|
    define_method "bb1_#{name}" do
      object.bebes.first.send(name) if object.bebes.any?
    end
  end

  def bb1_poids
    object.bebes.first.poids if object.bebes.any?
  end

  def bb1_taille
    object.bebes.first.taille if object.bebes.any?
  end

  %w(indication expo_terme).each do |name|
    define_method name do
      object.expositions.first.send(name).try(:name)
    end
  end

  %w(de a de2 a2 dose).each do |name|
    define_method name do
      object.expositions.first.send(:try, name)
    end
  end

  %w(malformation pathologie).each do |mp|
    define_method mp do
      if object.bebes.any?
        Dossier::ONI.each do |value|
          if object.bebes.any? {|b| b.send(mp) == value}
            return value
          end
        end
        return "non spécifié" if object.bebes.any? {|b| b.send(mp) == nil}
      end
    end
  end

  %w(expo_terato ass_med_proc toxiques folique patho1t path_mat).each do |method|
    define_method method do
      handle_none object.send(method) do
        object.send(method)
      end
    end
  end

  %w(age_grossesse terme).each do |sa|
    define_method sa do
      handle_none object.send(sa), nil do
        object.send(sa).to_s
      end
    end
  end

  def atcds_grs
    attribute = object.grsant
    handle_none attribute do
      if attribute == 0
        result = "primipare-primigeste"
      else
        result = attribute.to_s
        gestes = {}
        %w(fcs geu miu ivg img nai).each do |geste|
          if geste == "nai"
            gestes["naissance"] = object.send(geste)
          else
            gestes[geste] = object.send(geste)
          end
        end
        autres = []
        gestes.each do |k, v|
          if v && v > 0
            if k == "naissance"
              autres.push "#{h.pluralize(v, k)}"
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
      attribute = object.send("antecedents_#{atcds}")
      handle_none attribute do
        case attribute
        when "Non" then "Non"
        when "Oui" then self.send("comm_antecedents_#{atcds}")
        else
          "NSP"
        end
      end
    end
  end

  def patiente
    object.patiente_fullname
  end

  def patient_data
    [age, poids_taille_imc].compact.join(", ")
  end

  def age
    value_with_unit object.age, "ans"
  end

  def poids
    value_with_unit object.poids, "kg"
  end

  def taille
    value_with_unit object.taille, "cm"
  end

  def imc
    object.imc if object.imc
  end

  def poids_taille_imc
    result = [poids, taille].join(" x ")
    result << " (IMC #{imc})" if imc
  end


  %w(appel dernieres_regles debut_grossesse accouchement_prevu reelle_accouchement recueil_evol).each do |date|
    method_name = "date_#{date}"
    define_method method_name do
      handle_none object.send(method_name) do
        localize_date object.send(method_name)
      end
    end
  end

  def produit_name(index)
    if object.produits.any?
      object.produits[index].try(:name)
    end
  end

  def expositions(parse=true)
    handle_none object.produits_names, "Aucune" do
      parse ? twipsy(object.produits_names) : object.produits_names
    end
  end

  private

  def value_with_unit(value, unit)
    if value.present?
      "#{value} #{unit}"
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end

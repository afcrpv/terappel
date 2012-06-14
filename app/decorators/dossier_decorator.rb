#encoding: utf-8
class DossierDecorator < ApplicationDecorator
  decorates :dossier
  decorates_association :correspondant

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

  def correspondant
    handle_none dossier.correspondant do
      dossier.correspondant
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

  def liste_bebes
    if dossier.bebes.any?
      rows = ""
      dossier.bebes.each_with_index do |bebe, index|
        fields = []
        %w(poids taille pc).each do |field|
          label = ""
          value = bebe.send(field)
          if value
            label += field
            label = "P" if field == "poids"
            label = "T" if field == "taille"
            label = "<strong>#{label.upcase}</strong>"
            suffix = ""
            suffix += " g" if field == "poids"
            suffix += " cm" if %w(taille pc).include?(field)
            fields.push label + " " + value.to_s + suffix
          end
        end
        bebe_label = h.content_tag :span, "Bébé #{index + 1 if dossier.bebes.many?}", class: "libelle"
        apgar_values = []
        %w(apgar1 apgar5).each do |ap|
          value = bebe.send(ap)
          apgar_values.push value if value
        end
        apgar = ""
        apgar += ", " + h.content_tag(:strong, "Apgar") + " " + apgar_values.compact.join("-") if apgar_values.any?
        gap = h.content_tag :div, "&nbsp;".html_safe, class: "span1"
        malf_path_fields = []
        %w(malformation pathologie).each do |morp|
          label = ""
          value = bebe.send(morp)
          if value
            label += morp
            label = h.content_tag :strong, label.upcase
            malf_path_fields.push label + " " + value
          end
        end
        malform_path = h.content_tag :div, gap + h.content_tag(:div, malf_path_fields.compact.join(", ").html_safe, class: "span10"), class: "row"
        columns = h.content_tag(:div, bebe_label, class: "span1") + h.content_tag(:div, fields.join(", ").html_safe + apgar.html_safe, class: "span10")
        rows += h.content_tag :div, columns, class: "row"
        rows += malform_path

      end
      rows.html_safe
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

  def age
    handle_none dossier.age do
      dossier.age.to_s + " ans"
    end
  end

  def patiente
    handle_none dossier.patiente_fullname do
      dossier.patiente_fullname
    end
  end

  def button_to_modal
    h.button_tag id: dossier.id, class: "btn btn-small opener" do
      h.safe_concat "<i class='icon-info-sign'></i>" + "\nDétails"
    end
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
    if produits.any?
      produits[index].try(:name)
    end
  end

  %w(expositions bebes).each do |name|
    define_method "#{name}_table" do |fields|
      association = dossier.send(name)
      if association.any?
        rows = []
        association.each do |assoc|
          cells = []
          fields.each do |field|
            value = assoc.send(field) || " - "
            cells.push h.content_tag(:td, value.to_s)
          end
          rows.push h.content_tag(:tr, cells.join("\n").html_safe)
        end
        rows.join("\n").html_safe
      end
    end
  end

  def expositions
    handle_none dossier.produits_names, "Aucune", nil do
      twipsy dossier.produits_names
    end
  end

  private

  def method_missing (method, *args, &block)
    call = dossier.send(method, *args, &block)
    handle_none call do
      call
    end
  end
  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by calling this method:
  #     lazy_helpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"), 
  #                   :class => 'timestamp'
  #   end
end

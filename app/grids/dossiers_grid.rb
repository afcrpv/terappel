class DossiersGrid
  include Datagrid

  attr_accessor :current_user

  scope do
    Dossier.includes(:expositions, :produits)
  end

  filter(:date_appel, :date,
         range: true,
         default: proc do
           [Dossier.minimum(:date_appel),
            Dossier.maximum(:date_appel)]
         end)

  filter(:name, :string) { |value| where('name ilike ?', "%#{value}%") }

  column(:code, order: false)

  column(:date_appel) do |record|
    record.date_appel && I18n.l(record.date_appel)
  end

  column(:name, order: false)
  column(:expositions, order: false, html: true) do |record|
    if record.expositions.any?
      value = record.produits_names
      content_tag(:a, truncate(value, length: 20),
                  href: '#', data: { toggle: 'tooltip' }, title: value)
    else
      'AUCUNE'
    end
  end

  column(:evolution, order: false)

  column(:actions, html: true) do |record|
    actions = [
      link_to(fa_icon('print'), '#',
              data: { base_url: dossier_path(record), target: '#dossier_modal',
                      toggle: 'modal', dossier_code: record.code },
              title: "Imprimer le dossier #{record.code}",
              class: 'btn btn-default btn-sm show-dossier-modal'),
      link_to(fa_icon('pencil'),
              edit_dossier_path(record),
              title: "Modifier le dossier #{record.code}",
              class: 'btn btn-default btn-sm')
    ]
    content_tag(:div, actions.join("\n").html_safe, class: 'btn-group')
  end
end

module SearchesHelper
  def display_query_sql(dossiers)
    content_tag(:span, "Requête SQL", class: 'libelle') + dossiers.to_sql
  end
end

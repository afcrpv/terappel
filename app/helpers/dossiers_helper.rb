module DossiersHelper
  def model_fields
    # which fields to display and sort by
    [:code, :localized_dateappel, :patiente_fullname, :produits_names]
  end

  def results_limit
    # max number of search results to display
    100
  end

  def display_query_sql(dossiers)
    "SQL: #{dossiers.to_sql}"
  end

  def display_results_header(count)
    if count > results_limit
      "#{results_limit} premiers dossiers sur #{count} au total"
    elsif
      count > 300
      "Attention ! Plus de 300 résultats. Veuillez exporter en excel. "
    else
      "Résultat : #{pluralize(count, 'dossier')}"
    end
  end

  def action
    action_name == 'search' ? :post : :get
  end

  def display_sort_column_headers(search)
    model_fields.each_with_object('') do |field, string|
      string << content_tag(:th, sort_link(search, field, {}, method: action))
    end
  end

  def display_search_results(objects)
    objects.limit(results_limit).each_with_object('') do |object, string|
      string << content_tag(:tr, display_search_results_row(object))
    end
  end

  def display_search_results_row(object)
    model_fields.each_with_object('') do |field, string|
      string << content_tag(:td, object.send(field))
    end
    .html_safe
  end
end

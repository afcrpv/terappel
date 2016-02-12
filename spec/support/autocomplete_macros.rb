module AutocompleteMacros
  def choose_autocomplete_result(text, input_id = 'input[data-autocomplete]')
    page.execute_script %{ $('#{input_id}').trigger("focus") }
    page.execute_script %{ $('#{input_id}').trigger("keydown") }
    sleep 1
    page.execute_script %{ $('.typeahead a:contains("#{text}")').trigger("mouseenter").trigger("click"); }
  end
end

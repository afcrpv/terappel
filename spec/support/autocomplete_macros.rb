module AutocompleteMacros
  def choose_autocomplete_result(text, input_id="input[data-autocomplete]")
    page.execute_script %Q{ $('#{input_id}').trigger("focus") }
    page.execute_script %Q{ $('#{input_id}').trigger("keydown") }
    sleep 1
    page.execute_script %Q{ $('.typeahead a:contains("#{text}")').trigger("mouseenter").trigger("click"); }
  end
end
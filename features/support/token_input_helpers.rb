module TokenInputHelpers
  def token_input(locator, options)
    raise "Must pass a hash containing 'with'" unless options.is_a?(Hash) && options.has_key?(:with)

    # find the field that will ultimately be sent to the server, the one the user intends to fill in
    field = _find_fillable_field(locator)

    # Delete the existing token, if present
    begin
      # This xpath is finds a <ul class='token-input-list'/> followed by a <input id="ID"/>
      within(:xpath, "//ul[@class='token-input-list' and following-sibling::input[@id='#{field[:id]}']]") do
        find(:css, ".token-input-delete-token").click
      end
    rescue Capybara::ElementNotFound
      # no-op
    end
    ti_field = _find_fillable_field("token-input-#{field[:id]}") # now find the token-input
    ti_field.set(options[:with]) # 'type' in the value
    wait_for_ajax
    within(:css, ".token-input-dropdown-facebook") { find("li:contains('#{options[:with]}')").click } # find the matching element, and click on it
  end

  def wait_for_ajax
    wait_until { page.evaluate_script('$.active') == 0 }
  end

  protected
    def _find_fillable_field(locator)
      find(:xpath, XPath::HTML.fillable_field(locator), :message => "cannot fill in, no text field, text area or password field with id, name, or label '#{locator}' found")
    end
end
World(TokenInputHelpers)

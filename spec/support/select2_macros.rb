module Select2Macros
  def select2(value, options = {})
    raise "Must pass a hash containing 'from' or 'xpath'" unless options.is_a?(Hash) && [:from, :xpath].any? { |k| options.key? k }

    if options.key? :xpath
      select2_container = first(:xpath, options[:xpath])
    else
      select_name = options[:from]
      select2_container = first('label', text: select_name).find(:xpath, '..').find('.select2-container')
    end

    select2_container.find('.select2-selection').click

    if options.key? :search
      find(:xpath, '//body').find('input.select2-search__field').set(value)
      page.execute_script(%|$("input.select2-search__field:visible").keyup();|)
      drop_container = '.select2-results'
    else
      drop_container = '.select2-drop'
    end

    [value].flatten.each do |value|
      find(:xpath, '//body').find("#{drop_container} li", text: value).click
    end
  end
end

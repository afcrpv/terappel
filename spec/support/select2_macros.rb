module Select2Macros
  def select2(value, options = {})
    raise "Must pass a hash containing 'from' or 'xpath'" unless options.is_a?(Hash) && [:from, :xpath].any? { |k| options.key? k }

    if options.key? :xpath
      select2_container = first(:xpath, options[:xpath])
    else
      select_name = options[:from]
      select2_container = first('label', text: select_name).find(:xpath, '..').find('.select2-container')
    end

    select2_container.find('.select2-choice').click

    if options.key? :search
      find(:xpath, '//body').find('input.select2-input').set(value)
      page.execute_script(%|$("input.select2-input:visible").keyup();|)
      drop_container = '.select2-results'
    else
      drop_container = '.select2-drop'
    end

    [value].flatten.each do |value|
      choices_container = select2_container.find(:xpath, "a[contains(concat(' ',normalize-space(@class),' '),' select2-choice ')] | ul[contains(concat(' ',normalize-space(@class),' '),' select2-choices ')]")
      choices_container.trigger('click')
      find(:xpath, '//body').find("#{drop_container} li", text: value).click
    end
  end
end

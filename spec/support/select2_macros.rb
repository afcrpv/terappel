module Select2Macros
  def select2(id, text, options={})
    raise "Must pass a hash containing 'from'" if not options.is_a?(Hash) or not options.has_key?(:from)

    placeholder = options[:from]

    js = %|$(".select2-container:contains('#{placeholder}')").parent().find("input[name], select[name]").select2("data", {id: #{id}, text: "#{text}"});|

    page.execute_script js

    page.should_not have_content placeholder
    page.should have_content text
  end
end

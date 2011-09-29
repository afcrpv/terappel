When /^I fill in the "([^"]*)" field with "([^"]*)"$/ do |label, value|
  steps %Q{
    When I fill in "#{I18n.t(label)}" with "#{value}"
  }
end

#encoding: utf-8
Then /^show me the page$/ do
  save_and_open_page
end

Given /^an? existing (.*) with (.*) "([^\"]*)"$/ do |factory, field, value|
  FactoryGirl.create(factory, field.to_sym => value)
end

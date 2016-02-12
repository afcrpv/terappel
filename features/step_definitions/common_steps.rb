Then /^show me the page$/ do
end

Given /^an existing (.*) with (.*) "([^\"]*)"$/ do |factory, field, value|
  FactoryGirl.create(factory, field.to_sym => value)
  factory.classify.constantize.where(field.to_sym => value).should_not be_nil
end

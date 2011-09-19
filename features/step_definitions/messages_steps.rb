When /^I should see a "([^\"]*)" message$/ do |key|
   page.should have_content(I18n.t(key))
end

When /^I should not see a "([^\"]*)" message$/ do |key|
   page.should have_no_content(I18n.t(key))
end

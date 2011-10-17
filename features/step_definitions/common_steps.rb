#encoding: utf-8
Then /^show me the page$/ do
  save_and_open_page
end

When /^I press the destroy button$/ do
  page.click_link I18n.t('actions.destroy')
  dialog = page.driver.browser.switch_to.alert
  dialog.text.should == I18n.t('actions.confirm')
  dialog.accept
end

Then /^the ([^"]*) should be destroyed$/ do |resource|
  page.should have_content I18n.t("flash.destroy", :resource => I18n.t('activerecord.models.' + resource))
end

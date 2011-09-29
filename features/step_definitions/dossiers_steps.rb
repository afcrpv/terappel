When /^I press the create dossier button$/ do
  steps %Q{
    When I press "#{I18n.t('helpers.submit.create', :model => Dossier)}"
  }
end

When /^I press the update dossier button$/ do
  steps %Q{
    When I press "#{I18n.t('helpers.submit.update', :model => Dossier)}"
  }
end

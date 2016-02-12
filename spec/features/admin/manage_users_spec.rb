require 'rails_helper'

feature 'Admin manage users' do
  given!(:centre) { create(:centre) }
  given(:admin) { create(:admin) }

  background { login admin }

  scenario 'update'
  scenario 'approve'
  scenario 'receives email notification of user registration'
end

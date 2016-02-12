require 'rails_helper'

describe 'routes for Sessions' do
  it 'routes /login to devise/sessions#new' do
    expect(get: '/login').to route_to(controller: 'devise/sessions', action: 'new')
  end
  it 'routes /logout to devise/sessions#destroy' do
    expect(get: '/logout').to route_to(controller: 'devise/sessions', action: 'destroy')
  end
end

require 'spec_helper'

describe 'routes for Sessions' do
  it 'routes /login to devise/sessions#new' do
    { get: '/login' }
      .should route_to(controller: 'devise/sessions', action: 'new')
  end
  it 'routes /logout to devise/sessions#destroy' do
    { get: '/logout' }
      .should route_to(controller: 'devise/sessions', action: 'destroy')
  end
end

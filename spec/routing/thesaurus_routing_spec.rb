require 'rails_helper'

describe 'routes for Thesaurus' do
  it 'routes /admin/table_generales to admin/thesaurus#dashboard' do
    expect(get: '/admin/tables_generales')
      .to route_to(controller: 'admin/thesaurus', action: 'dashboard')
  end
  it 'routes /admin/table_generales/foo to admin/thesaurus#index' do
    expect(get: '/admin/tables_generales/foo')
      .to route_to(controller: 'admin/thesaurus', action: 'index', name: 'foo')
  end
  it 'routes /admin/table_generales/foo/new to admin/thesaurus#new' do
    expect(get: '/admin/tables_generales/foo/new')
      .to route_to(controller: 'admin/thesaurus', action: 'new', name: 'foo')
  end
  it 'routes /admin/table_generales/foo/bar to admin/thesaurus#create' do
    expect(post: '/admin/tables_generales/foo/bar')
      .to route_to(controller: 'admin/thesaurus', action: 'create', name: 'foo', id: 'bar')
  end
  it 'routes /admin/table_generales/foo/bar/edit to admin/thesaurus#edit' do
    expect(get: '/admin/tables_generales/foo/bar/edit')
      .to route_to(controller: 'admin/thesaurus', action: 'edit', name: 'foo', id: 'bar')
  end
  %w(put patch).each do |action|
    it "routes #{action.upcase} /admin/table_generales/foo/bar to admin/thesaurus#update" do
      expect(action => '/admin/tables_generales/foo/bar')
        .to route_to(controller: 'admin/thesaurus', action: 'update', name: 'foo', id: 'bar')
    end
  end
  it 'routes /admin/table_generales/foo/bar to admin/thesaurus#destroy' do
    expect(delete: '/admin/tables_generales/foo/bar')
      .to route_to(controller: 'admin/thesaurus', action: 'destroy', name: 'foo', id: 'bar')
  end
end

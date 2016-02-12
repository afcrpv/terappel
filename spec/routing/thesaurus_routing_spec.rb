require 'spec_helper'

describe 'routes for Thesaurus' do
  it 'routes /admin/table_generales to admin/thesaurus#dashboard' do
    { get: '/admin/tables_generales' }
      .should route_to(controller: 'admin/thesaurus', action: 'dashboard')
  end
  it "routes /admin/table_generales/foo to admin/thesaurus#index with 'foo' as :name param" do
    { get: '/admin/tables_generales/foo' }
      .should route_to(controller: 'admin/thesaurus', action: 'index', name: 'foo')
  end
  it "routes /admin/table_generales/foo/new to admin/thesaurus#new with 'foo' as :name param" do
    { get: '/admin/tables_generales/foo/new' }
      .should route_to(controller: 'admin/thesaurus', action: 'new', name: 'foo')
  end
  it "routes /admin/table_generales/foo/bar to admin/thesaurus#create with 'foo'/'bar' as :name/:id params" do
    { post: '/admin/tables_generales/foo/bar' }
      .should route_to(controller: 'admin/thesaurus', action: 'create', name: 'foo', id: 'bar')
  end
  it "routes /admin/table_generales/foo/bar/edit to admin/thesaurus#edit with 'foo'/'bar' as :name/:id params" do
    { get: '/admin/tables_generales/foo/bar/edit' }
      .should route_to(controller: 'admin/thesaurus', action: 'edit', name: 'foo', id: 'bar')
  end
  %w(put patch).each do |action|
    it "routes #{action.upcase} /admin/table_generales/foo/bar to admin/thesaurus#update with 'foo'/'bar' as :name/:id params" do
      { action => '/admin/tables_generales/foo/bar' }
        .should route_to(controller: 'admin/thesaurus', action: 'update', name: 'foo', id: 'bar')
    end
  end
  it "routes /admin/table_generales/foo/bar to admin/thesaurus#destroy with 'foo'/'bar' as :name/:id params" do
    { delete: '/admin/tables_generales/foo/bar' }
      .should route_to(controller: 'admin/thesaurus', action: 'destroy', name: 'foo', id: 'bar')
  end
end

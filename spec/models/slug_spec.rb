require 'spec_helper'

shared_examples_for 'a slugged resource' do |model|
  let(:klass) { model.classify.constantize }
  it 'requires a unique slug' do
    create(model, name: 'Name')
    new_instance = klass.new(name: 'name')
    new_instance.should have(1).error_on(:slug)
  end

  it 'rejects a restricted word slug' do
    %w(index new session login logout users).each do |restricted_word|
      klass.new(name: restricted_word).should have(1).error_on(:slug)
    end
  end

  it 'is slugged' do
    create(model, name: 'Name').to_param.should eq 'name'
  end
end

describe Centre do
  it_behaves_like 'a slugged resource', 'centre'
end

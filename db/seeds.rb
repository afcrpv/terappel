# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
require 'csv'

#Dir[Rails.root.join('./db', 'seeds', '*.rb').to_s].each do |file|
  #puts "Loading db/seeds/#{file.split(File::SEPARATOR).last}"
  #load(file)
#end

load Rails.root.join('./db', 'seeds', '0_thesaurus.rb')
#load Rails.root.join('./db', 'seeds', '1_dossiers.rb')
#load Rails.root.join('./db', 'seeds', '2_correspondants.rb')
#load Rails.root.join('./db', 'seeds', '3_expositions.rb')
#load Rails.root.join('./db', 'seeds', '4_bebes.rb')

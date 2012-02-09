# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

require 'csv'

puts "creating first Centre"
Centre.where(name: "Lyon").first_or_create!(code: "LY")

# create Motif
puts "importing Motifs table from csv"
CSV.foreach("csv/motifs.csv", headers: true) do |row|
  Motif.where(name: row['name']).first_or_create!(oldid: row['oldid'])
end

# create Evolution
puts "importing Evolution table from csv"
CSV.foreach("csv/evolutions.csv", headers: true) do |row|
  Evolution.where(name: row['name']).first_or_create!(oldid: row['oldid'])
end

# create ExpoType
puts "importing ExpoType table from csv"
CSV.foreach("csv/expo_types.csv", headers: true) do |row|
  ExpoType.where(name: row['name']).first_or_create!(oldid: row['oldid'])
end

# create ExpoNature
puts "importing ExpoNature table from csv"
CSV.foreach("csv/expo_natures.csv", headers: true) do |row|
  ExpoNature.where(name: row['name']).first_or_create!(oldid: row['oldid'])
end

# create ExpoTerme
puts "importing ExpoTerme table from csv"
CSV.foreach("csv/expo_termes.csv", headers: true) do |row|
  ExpoTerme.where(name: row['name']).first_or_create!(oldid: row['oldid'])
end

# create Indication
puts "importing Indication table from csv"
CSV.foreach("csv/indications.csv", headers: true) do |row|
  Indication.where(name: row['name']).first_or_create!(oldid: row['oldid'])
end


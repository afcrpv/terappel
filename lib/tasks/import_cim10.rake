namespace :db do
  desc 'Import cim10 from a csv'
  task import_cim10: :environment do
    require 'csv'

    Maladie.destroy_all if Maladie.all.any?

    puts 'Importing Maladies'

    CSV.foreach('csv/cim10.csv', headers: true, col_sep: ';') do |row|
      puts "processing row #{row['code']}"
      Maladie.create!(
        code: row['code'],
        pere: row['père'],
        libelle: row['libelle'],
        leaf: row['chapitre'].downcase.first == 'f' ? true : false
      )
    end

    puts 'Filling up name using libelle'

    collection = Maladie.all
    collection.each do |c|
      puts "processing maladie #{c.libelle}"
      c.name = (name = c.libelle.split(' - ')).many? ? name.second : name.first
      pere = Maladie.find_by_code(c.pere)
      unless pere.nil?
        c.parent_id = pere.id
        c.save!
      end
    end
  end
end

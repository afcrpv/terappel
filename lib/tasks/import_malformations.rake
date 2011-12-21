namespace :db do
  desc "Import malformations from a csv"
  task :import_malformations => :environment do
    require 'csv'

    Malformation.destroy_all if Malformation.all.any?

    puts "Importing Malformations"
    CSV.foreach("csv/malformations.csv", headers: true) do |row|
      Malformation.create!(
        :codeterme => row['CodeTerme'],
        :codetermepere => row['CodeTermePere'],
        :libabr => row['libabr'],
        :level => row['level'],
        :libelle => row['libelle']
      )
    end

    puts "Filling up parent_id using codeterme and codetermepere"
    malfs = Malformation.all
    malfs.each do |m|
      pere = Malformation.find_by_codeterme(m.codetermepere)
      unless pere.nil?
        m.parent_id = pere.id
        m.save!
      end
    end
  end
end

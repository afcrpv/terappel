namespace :db do
  desc 'Import malformations/pathologies from a csv'
  task import_malfs_paths: :environment do
    require 'csv'

    %w(malformation pathologie).each do |name|
      klass = name.classify.constantize
      klass.destroy_all if klass.all.any?

      puts "Importing #{name.pluralize}"
      CSV.foreach("csv/#{name.pluralize}.csv", headers: true) do |row|
        klass.create!(
          codeterme: row['CodeTerme'],
          codetermepere: row['CodeTermePere'],
          libabr: row['libabr'],
          level: row['level'],
          libelle: row['libelle']
        )
      end

      puts 'Filling up parent_id using codeterme and codetermepere'
      collection = klass.all
      collection.each do |c|
        pere = klass.find_by_codeterme(c.codetermepere)
        unless pere.nil?
          c.parent_id = pere.id
          c.save!
        end
      end
    end
  end
end

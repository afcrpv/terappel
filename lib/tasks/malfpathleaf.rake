namespace :db do
  desc 'Fill up leaf field for malformations and pathologies'
  task malfpathleaf: :environment do

    %w(malformation pathologie).each do |name|
      klass = name.classify.constantize

      klass.find_each do |c|
        c.leaf = true if c.is_childless?
        c.save!
      end
    end
  end
end

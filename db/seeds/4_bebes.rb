# create Bebes
# vim global for bebes vides :g/\d\{2},"\w\+",,,,,,,,/d
puts "importing Bebe table from csv"
CSV.foreach("csv/bebes.csv", headers: true) do |row|
  oldid =  row['nappelsaisi'][0..1]+row['nbebe'].to_s
  puts "processing row##{oldid}"
  if (dossier = Dossier.where(code: row['nappelsaisi']).first)
    malformation = case row['malforma']
                   when "NSP"
                     "NSP"
                   when "O"
                     "Oui"
                   when "N"
                     "Non"
                   else
                     nil
                   end
    pathologie = case row['patho']
                   when "NSP"
                     "NSP"
                   when "O"
                     "Oui"
                   when "N"
                     "Non"
                   else
                     nil
                   end
    Bebe.find_or_create_by!(oldid: oldid,
                            dossier_id: dossier.id,
                            malformation: malformation,
                            pathologie: pathologie,
                            sexe: row['sexe'],
                            poids: row['poids'],
                            apgar1: row['apgar'],
                            apgar5: row['apgar2'],
                            pc: row['pc'],
                            taille: row['taille']
                           )
  end
end

%w(malformation pathologie).each do |name|
  klass = name.classify.constantize

  puts "Importing #{name.pluralize} from csv"
  CSV.foreach("csv/#{name.pluralize}.csv", headers: true) do |row|
    oldid = row["n#{name}"]
    puts "processing row##{oldid}"
    klass.find_or_create_by!(oldid: oldid,
      codeterme: row['CodeTerme'],
      codetermepere: row['CodeTermePere'],
      libabr: row['libabr'],
      level: row['level'],
      libelle: row['libelle']
  )
  end

  puts "Filling up parent_id using codeterme and codetermepere"
  collection = klass.all
  collection.each do |item|
    pere = klass.where(codeterme: item.codetermepere).first
    unless pere.nil?
      item.parent_id = pere.id
      item.save!
    end
  end

  puts "Importing Bebe #{name.pluralize}"
  CSV.foreach("csv/bebes_#{name.pluralize}.csv", headers: true) do |row|
    oldid = row['nappelsaisi'][0..1]+row['nbebe'].to_s
    puts "processing row##{oldid}"
    bebe = Bebe.where(oldid: oldid).first
    bebe.send(:"#{name.pluralize}") << klass.where(oldid: row["n#{name}"]).first
  end
end

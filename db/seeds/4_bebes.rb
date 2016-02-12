# create Bebes
# vim global for bebes vides :g/\d\{2},"\w\+",,,,,,,,/d
puts 'importing Bebe table from csv'
CSV.foreach('csv/bebes.csv', headers: true) do |row|
  oldid = row['nappelsaisi'][0..1] + row['nbebe'].to_s
  sexe = case row['sexe']
         when 'M'
           'M'
         when 'F'
           'F'
         else
           'I'
         end
  if (dossier = Dossier.where(code: row['nappelsaisi']).first)
    puts "processing bebe##{oldid}"
    malformation = case row['malforma']
                   when 'O'
                     'Oui'
                   when 'N'
                     'Non'
                   else
                     'NSP'
                   end
    pathologie = case row['patho']
                 when 'O'
                   'Oui'
                 when 'N'
                   'Non'
                 else
                   'NSP'
                   end
    Bebe.find_or_create_by!(oldid: oldid,
                            dossier_id: dossier.id,
                            malformation: malformation,
                            pathologie: pathologie,
                            sexe: sexe,
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

  puts "Importing Bebe #{name.pluralize}"
  CSV.foreach("csv/bebes_#{name.pluralize}.csv", headers: true) do |row|
    oldid = row['nappelsaisi'][0..1] + row['nbebe'].to_s
    puts "processing row##{oldid}"
    bebe = Bebe.find_by(oldid: oldid)
    if bebe
      puts "adding #{name} to bebe##{oldid}"
      bebe.send(:"#{name.pluralize}") << klass.find_by(oldid: row["n#{name}"])
    end
  end
end

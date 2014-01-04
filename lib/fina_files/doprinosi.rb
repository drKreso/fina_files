#encoding:utf-8
require 'bigdecimal'
require 'date'

class Doprinosi
  def self.configure(&block)
    define_singleton_method :postavke do
      block.call
    end
  end

  #oznaka prethodni godina mjesec
  def self.godina_mjesec
    (DateTime.now << 1).strftime('%y%m')
  end

  def self.poziv_na_broj_godina_dan
    (DateTime.now).strftime('%y') << ( "%03d" % DateTime.now.day )
  end

  def self.nalozi
   result = [
    [ "HR68 8168-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'MIO I STUP',get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:mio_i] ],
    [ "HR68 2283-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'MIO II STUP',get_iban('1001005-1700036001'),'DOPRINOS ZA MIROVINSKO OSIGURANJE', postavke[:mio_ii] ],
    [ "HR68 8486-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'Doprinos za osnovno zdravstveno osiguranja',get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:zdravstveno_osiguranje] ],
    [ "HR68 8630-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'Doprinos za ozljede na radu',get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:ozljede_na_radu] ],
    [ "HR68 8753-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'Doprinos za zaposljavanje',get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:zaposljavanje]],
   ]
    #broj racuna je za grad Zagreb
    unless postavke[:porez_prirez_dohodak].nil?
      result << [ "HR68 1406-#{postavke[:oib_platitelja]}","Porez prirez dohodak #{godina_mjesec}",get_iban('1001005-1713312009'),'Grad Zagreb', postavke[:porez_prirez_dohodak]]
    end

    unless postavke[:place].nil?
      postavke[:place].each do |placa|
        result << [ "HR67 #{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}-0",'Isplata place',get_iban("#{placa[:racun]}"),"#{placa[:prima]}", placa[:iznos] ]
      end
    end
    unless postavke[:pdv].nil?
      result << [ "HR68 1201-#{postavke[:oib_platitelja]}","PDV #{godina_mjesec}",get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:pdv]]
    end
    result
 end

 def self.get_iban(account)
   return account if account.length == 21
   clean_account = account.strip.gsub('-','').gsub(' ', '')
   check_digits = 98 - "172700#{clean_account}".split('').rotate(6).join.to_i % 97
   "HR#{check_digits < 10 ? "0#{check_digits}" : check_digits}#{clean_account}"
 end

end

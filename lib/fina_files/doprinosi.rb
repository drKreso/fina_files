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
    (DateTime.now).strftime('%y') << ( "%03d" % DateTime.now.yday )
  end

  def self.nalozi
   result = [
    [ "HR99", "HR68 8168-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'MIO I STUP',get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:mio_i] ],
    [ "HR99", "HR68 2283-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'MIO II STUP',get_iban('1001005-1700036001'),'DOPRINOS ZA MIROVINSKO OSIGURANJE', postavke[:mio_ii] ],
    [ "HR99", "HR68 8486-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'Doprinos za osnovno zdravstveno osiguranja', 'HR6510010051550100001','DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:zdravstveno_osiguranje] ],
    [ "HR99", "HR68 8630-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'Doprinos za ozljede na radu','HR6510010051550100001','DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:ozljede_na_radu] ],
    [ "HR99", "HR68 8753-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}",'Doprinos za zaposljavanje',get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:zaposljavanje]],
   ]
    #broj racuna je za grad Zagreb
    unless postavke[:porez_prirez_dohodak].nil?
      result << ["HR99", "HR68 1880-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}","Porez prirez dohodak #{godina_mjesec}",get_iban('1001005-1713312009'),'Grad Zagreb', postavke[:porez_prirez_dohodak]]
    end

    #broj racuna je za grad Donju Stubicu
    unless postavke[:porez_prirez_dohodak_donja_stubica].nil?
      result << ["HR99", "HR68 1880-#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}","Porez prirez dohodak #{godina_mjesec}", "HR8710010051707912009", 'Donja Stubica', postavke[:porez_prirez_dohodak_donja_stubica]]
    end

    unless postavke[:place].nil?
      postavke[:place].each do |placa|
        result << ["HR67#{postavke[:oib_platitelja]}-#{poziv_na_broj_godina_dan}-0", "HR69 40002-#{postavke[:oib_platitelja]}-100",'Isplata place',get_iban("#{placa[:racun]}"),"#{placa[:prima]}", placa[:iznos] ]
      end
    end

    unless postavke[:pdv].nil?
      result << ["HR99", "HR68 1201-#{postavke[:oib_platitelja]}","PDV #{godina_mjesec}",get_iban('1001005-1863000160'),'DRZAVNI PRORACUN REPUBLIKE HRVATSKE', postavke[:pdv]]
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

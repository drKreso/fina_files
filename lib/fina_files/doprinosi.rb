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

  def self.nalozi
   result = [
    [ "HR68 8109-#{postavke[:oib_platitelja]}-#{godina_mjesec}",'MIO I STUP','1001005-1863000160','DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE', postavke[:mio_i] ],
    [ "HR68 2003-#{postavke[:oib_platitelja]}-#{godina_mjesec}",'MIO II STUP','1001005-1700036001','DOPRINOS ZA MIROVINSKO OSIGURANJE', postavke[:mio_ii] ],
    [ "HR68 8400-#{postavke[:oib_platitelja]}-#{godina_mjesec}",'Doprinos za osnovno zdravstveno osiguranja','1001005-1863000160','DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE', postavke[:zdravstveno_osiguranje] ],
    [ "HR68 8559-#{postavke[:oib_platitelja]}-#{godina_mjesec}",'Doprinos za ozljede na radu','1001005-1863000160','DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE', postavke[:ozljede_na_radu] ],
    [ "HR68 8702-#{postavke[:oib_platitelja]}-#{godina_mjesec}",'Doprinos za zaposljavanje','1001005-1863000160','DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE', postavke[:zaposljavanje]],
   ]
    #broj racuna je za grad Zagreb
    unless postavke[:porez_prirez_dohodak].nil?
      result << [ "HR68 1406-#{postavke[:oib_platitelja]}","Porez prirez dohodak #{godina_mjesec}",'1001005-1713312009','Grad Zagreb', postavke[:porez_prirez_dohodak]]
    end

    unless postavke[:place].nil?
      postavke[:place].each do |placa|
        result << [ "HR67 #{postavke[:oib_platitelja]}-#{godina_mjesec}-0",'Isplata place',"#{placa[:racun]}","#{placa[:prima]}", placa[:iznos] ]
      end
    end
    unless postavke[:pdv].nil?
      result << [ "HR68 1201-#{postavke[:oib_platitelja]}","PDV #{godina_mjesec}",'1001005-1863000160','DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE', postavke[:pdv]]
    end
    result
 end

end

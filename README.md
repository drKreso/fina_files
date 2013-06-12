# Fina files

Podržani su:

1. Generiranje FINA zbrojnog naloga
2. Import FINA format izvatka - skoro bez validacija, ali dobije se array prometa

Radi se o novom formatu koji je aktualan od 4. lipnja 2012 (Novi univerzalni HUB3 obrazac)

##  Instalacija

    $ gem install fina_files

## Zbrojni nalog za doprinose

Ovo je za napaćeni radni narod koji nema volje/živaca svaki mjesec raditi knjiženja našoj dragoj državnoj upravi (umjesto da ima mogućnost platiti jedan iznos).

Ogledni primjer:


```ruby
# !/usr/bin/env ruby
# encoding: UTF-8

require "fina_files"

# Podese se osnovni podaci
Doprinosi.configure do
    {
      :pdv => 100.00, #opcionalno
      :oib_platitelja => '55915703761',
      :mio_i => 574.60,
      :mio_ii => 191.53,
      :zdravstveno_osiguranje => 497.98,
      :ozljede_na_radu => 19.15,
      :zaposljavanje => 65.12,
      :porez_prirez_dohodak => 50.00, #opcionalno, racun je za grad Zagreb
      :place =>
        [
          { :prima => 'Petar Milenovic', :racun => '2484004-3235123152', :iznos => 3064.52 }
        ]
    }
end


# nakon toga se može generirati zbrojni nalog za željeni broj računa:
ZbrojniNalog.new("HR3624840081111111111").tap do |result|
  result.nalozi = Doprinosi.nalozi
  result.export(~/Desktop/doprinosi.hub3)
end
# Ogledni primjer za prošli mjesec u ~/Desktop/doprinosi.hub3 datoteci.
```

Za broj "mjeseca" koji treba kod naloga koji se generiraju uzima se prošli mjesec. Dakle ako 1.11.2012 radimo naloge poziv na broj za MIO I stup je:

```ruby
"HR68 8109-#{postavke[:oib_platitelja]}-#{godina_mjesec}" #=> "HR68 8109-58914703561-1210"
```

Ovo nije točan podatak ako je firma tek otvorena jer se u biti gleda redni broj doprinosa, a ne mjesec. Kada firma radi punu godinu onda je taj redni broj jednak broju mjeseca. Ako nekome treba može se dodati postavka :korekcija_mjeseca.


Lako je dodati recimo isplatu place za vise ljudi:

```ruby
Doprinosi.configure do
    {
          ....
        :place =>
        [
          { :prima => 'Mitar Mrkela', :racun => Doprinosi.get_iban('2484007-3255555551'), :iznos => 5700.00 },
          { :prima => 'Janko Bulic', :racun => Doprinosi.get_iban('2484007-3255555554'), :iznos => 5300.00 }
        ]
    }
end
```

Lako je dodati dodatne uplate koje se ponavljaju mjesecno, recimo


```ruby
ZbrojniNalog.new("HR3624840081105230796").tap do |result|
  result.nalozi = Doprinosi.nalozi #generiraju se stavke za doprinose

  avans_dobiti = 1_000.0

  if !avans_dobiti.nil? && avans_dobiti > 0
    result.nalozi << [ "HR99", "Avans dobiti", Doprinosi.get_iban("2484008-55555555555"), "Marko Jurjevac", avans_dobiti ]
    result.nalozi << [ "HR681570-OIB", "Porez i prirez na kapitalnu dobit", Doprinosi.get_iban("1001005-1713312009"), "POREZ I PRIREZ NA DOHODAK", (avans_dobiti * 0.12 * 1.18).round(2) ]
  end

  result.nalozi << [ "HR99",'Najam poslovnog prostora', Doprinosi.get_iban("2340009-3555555146"),"Ante Markovic", 5530.0 ]
  result.nalozi << [ "HR99",'Usluge', Doprinosi.get_iban("2340009-3555555555"),"Marko Markovic", 1000.0 ]

  result.export('~/Desktop/doprinosi.hub3')
end
```



* Garancija je - "AS IS" - molim da svi provjere naloge prije autorizacije jer ne mogu preuzeti odgovornost za moguće propuste.


Verzije
-------

0.0.8

Dodano placanje poreza i prireza na dohodak (grad Zagreb)


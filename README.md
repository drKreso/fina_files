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
      :oib_platitelja => '58914703561',
      :mio_i => 574.60,
      :mio_ii => 191.53,
      :zdravstveno_osiguranje => 497.98,
      :ozljede_na_radu => 19.15,
      :zaposljavanje => 65.12,
      :place =>
        [
          { :oib => 58914703561, :prima => 'Krešimir Bojčić', :racun => '2484004-3235123152', :iznos => 3064.52 }
        ]
    }
end

fname = '~/Desktop/doprinosi.hub3'

# nakon toga se može generirati zbrojni nalog za željeni broj računa:
ZbrojniNalog.new("HR3624840081111111111").tap do |result|
  result.nalozi = Doprinosi.nalozi
  result.export(fname)
end
puts "Ogledni primjer za prošli mjesec u #{fname} datoteci."
```

Za broj "mjeseca" koji treba kod naloga koji se generiraju uzima se prošli mjesec. Dakle ako 1.11.2012 radimo naloge poziv na broj za MIO I stup je:

```ruby
"HR68 8109-#{postavke[:oib_platitelja]}-#{godina_mjesec}" #=> "HR68 8109-58914703561-1210"
```

Ovo nije točan podatak ako je firma tek otvorena jer se u biti gleda redni broj doprinosa, a ne mjesec. Kada firma radi punu godinu onda je taj redni broj jednak broju mjeseca. Ako nekome treba može se dodati postavka :korekcija_mjeseca.

* Garancija je - "AS IS" - molim da svi provjere naloge prije autorizacije jer ne mogu preuzeti odgovornost za moguće propuste.




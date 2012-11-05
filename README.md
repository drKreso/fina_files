# Fina files

Podrzani su:

1. Import FINA format izvatka
2. Generiranje FINA zbrojnog naloga

Radi se o novom formatu koji je aktualan od 4. lipnja 2012 (Novi univerzalni HUB3 obrazac)

##  Instalacija

    $ gem install fina_files

## Zbrojni nalog za doprinose

Podese se osnovni podaci

```ruby
Doprinosi.configure do
    {
      :oib_platitelja => '58914703561',
      :mio_i => 574.60,
      :mio_ii => 191.53,
      :zdravstveno_osiguranje => 497.98,
      :ozljede_na_radu => 19.15,
      :zaposljavanje => 65.12,
      :place =>
        [
          { :oib => 58914703561, :prima => 'Kresimir Bojcic', :racun => '2484004-3235123152', :iznos => 3064.52 }
        ]
    }
end
```

I nakon toga se moze generirati zbrojni nalog

```ruby
ZbrojniNalog.new("HR3624840081111111111").tap do |result|
  result.nalozi = Doprinosi.nalozi
  result.export('~/Desktop/doprinosi.hub3')
end
```

* Garancija je - AS IS - molim da svi provjere naloge prije autorizacije jer ne mogu preuzeti odgovornost za moguce propuste.




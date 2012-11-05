# Fina files

Podrzani su:

1. Import FINA format izvatka
2. Generiranje FINA zbrojnog naloga

Radi se o novom formatu koji je aktualan od 4. lipnja 2012 (Novi univerzalni HUB3 obrazac)

##  Instalacija

Treba dodati redak u Gemfile

    gem 'fina_files'

I nakon toga izvrsiti:

    $ bundle

Ako se ne koristi u Rails aplikaciji dovoljno je samo instalirati ovako:

    $ gem install fina_files

## Zbrojni nalog

```ruby
zbrojni_nalog = ZbrojniNalog.new("HR362484008111111111")
zbrojni_nalog.nalozi = Doprinosi.nalozi # nalozi po formatu kao u testovima (array)
zbrojni_nalog.export('~/Desktop/doprinosi.hub3')
```


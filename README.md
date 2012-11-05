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
ZbrojniNalog.new("HR3624840081111111111").tap do |result|
  result.nalozi = NALOZI  #ovo je array naloga sa osnovnim podacima
  result.export('~/Desktop/doprinosi.hub3')
end
```

```ruby
 NALOZI = [
              [
                "HR68 8109-58914703561-1209",
                "MIO I STUP",
                "1001005-1863000160",
                "DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE",
                574.6
              ],
              [
                "HR68 2003-58914703561-1209",
                "MIO II STUP",
                "1001005-1700036001",
                "DOPRINOS ZA MIROVINSKO OSIGURANJE",
                191.53
              ]
           ]
```



#HUB3 verzija specifikacije
require 'date'
class FinaIzvadak
  DEFINICIJA= {
    "900" => 'a7a50a11a4a8a917a3',
    "903" => 'a7a11a21a3a70a35a8a11a3a3a8a4a4a809a3',
    "905" => 'a2a34a70a35a35a8a8a3a15a1a15a1a15a26a26a4a140a42a35a482a3',
    "907" => 'a21a3a70a3a3a8a8a1a15a1a15a8a15a15a1a15a1a15a1a15a1a15a4a6a420a317a3',
    "909" => 'a8a5a6a978a3',
    "999" => 'a997a3'
  }

  def type(line)
    raise "Duljina mora biti 1000 (dobio duljinu #{line.length} - znakovno: '#{line}')" unless line.length == 1000

    line.unpack('a997a3')[-1]
  end

  def decode(line)
    raise "Ne postoji slog tipa #{type(line)} koji je poslan" if DEFINICIJA[type(line)].nil?

    line.unpack(DEFINICIJA.fetch(type(line))).map(&:strip)
  end
  ####################
  # format prometa
  ####################
  # broj_izvoda
  # redni broj
  # datum izvoda
  # vrsta transakcije
  # transakcijski racun
  # valuta
  # racun stranka
  # naziv stranka
  # adresa stranka
  # mjesto stranka
  # datum valute
  # datum izvrsenja
  # iznos
  # poziv na broj platitelja
  # poziv na broj primatelja
  # opis prometa
  # identifikacijski broj prometa

  def prometi(izvadak)
    [].tap do |result|
      grupa = nil
      counter = nil
      izvadak.lines.map do |line|
        decoded = decode(line.chomp)
        tip = decoded[-1]
        if tip == "900"
          next
        elsif tip == "903"
          grupa = decoded
          counter = 0
        elsif tip == "905"
          counter += 1
          result << [
                      grupa[8].to_i,
                      counter,
                      DateTime.parse(grupa[10]),
                      decoded[0] == "10" ? :na_teret : :u_korist,
                      grupa[2],
                      grupa[3],
                      decoded[1],
                      decoded[2],
                      decoded[3],
                      decoded[4],
                      DateTime.parse(decoded[5]),
                      DateTime.parse(decoded[6]),
                      (BigDecimal.new(decoded[11] + decoded[12])/100.0).round(2),
                      decoded[13],
                      decoded[14],
                      decoded[16],
                      decoded[18]
                    ]
        elsif tip == "907"
          next
        elsif tip == "909"
          next
        elsif tip == "999"
          next
        end
      end
    end
  end

end
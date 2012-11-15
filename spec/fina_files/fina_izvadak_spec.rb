require 'fina_files/fina_izvadak'

describe FinaIzvadak do

 REDAK_900   = "2503009NOVABANKA D.D. ZAGREB                             78427478595100020121029                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     900"
 REDAK_903   = "2503009VBCRHR22   HR2225030091100023273HRKKOMNY D.O.O ZA TRGOVINU,TU                                            SPLIT                              03953084002782600102510002012102700011000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         903"
 REDAK_905_1 = "2025030091011111116                 KOMNY  D.O.O.                                                         DOMOVINSKOG RATA 72                SPLIT                              2012102720121027   000000000000000+000000000000000+000000000053000HR001010707032            HR026026102012                BONORA PARKING 26/10/2012                                                                                                                                                             20121027000022                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       905"
 REDAK_905_2 = "1025030091011111116                 KOMNY  D.O.O.                                                         DOMOVINSKOG RATA 72                SPLIT                              2012102720121027   000000000000000+000000000000000-000000000132000HR001010487032            HR02932610212                 POLOG                                                                                                                                                                                 20121027000097                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       905"
 REDAK_907   = "HR2225030091100023273HRKKOMNY D.O.O ZA TRGOVINU,TU                                            25100020121027        +000000198343125 00000000000000020130228000001000000000000000000000000+000001287360525+000000002870000+000000091887400+0000002873605250001000002                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 907"
 REDAK_909   = "2012102900001000002                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  909"
 REDAK_999   = "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     999"
 REDAK_KRIVI = "2503009NOVABANKA D.D. ZAGREB                             78427478595100020121029                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    900"
 REDAK_KRIVI_TIP = "2503009NOVABANKA D.D. ZAGREB                             78427478595100020121029                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     901"

 FINA_FILE   = "#{REDAK_900}\r\n#{REDAK_903}\r\n#{REDAK_905_1}\r\n#{REDAK_905_2}\r\n#{REDAK_907}\r\n#{REDAK_909}\r\n#{REDAK_999}"

 it 'zna prepoznati redak 900 i izvaditi podatke' do
  subject.decode(REDAK_900).should == ["2503009", "NOVABANKA D.D. ZAGREB", "78427478595", "1000", "20121029", "", "900"]
 end

 it 'zna prepoznati redak 903 i izvaditi podatke' do
   subject.decode(REDAK_903).should == ["2503009", "VBCRHR22", "HR2225030091100023273", "HRK", "KOMNY D.O.O ZA TRGOVINU,TU",
                                        "SPLIT", "03953084", "00278260010", "251", "000", "20121027", "0001", "1000", "", "903"]
 end

 it 'zna prepoznati redak 905 i izvaditi podatke' do
   subject.decode(REDAK_905_1).should == ["20", "25030091011111116", "KOMNY  D.O.O.", "DOMOVINSKOG RATA 72", "SPLIT", "20121027",
                                        "20121027", "", "000000000000000", "+", "000000000000000", "+", "000000000053000", "HR001010707032",
                                        "HR026026102012", "", "BONORA PARKING 26/10/2012", "", "20121027000022", "", "905"]
 end

 it 'zna prepoznati redak 907 i izvaditi podatke' do
   subject.decode(REDAK_907).should == ["HR2225030091100023273", "HRK", "KOMNY D.O.O ZA TRGOVINU,TU", "251", "000", "20121027", "",
                                        "+", "000000198343125", "", "000000000000000", "20130228", "000001000000000", "000000000000000",
                                        "+", "000001287360525", "+", "000000002870000", "+", "000000091887400", "+", "000000287360525",
                                        "0001", "000002", "", "", "907"]
 end

 it 'zna prepoznati redak 909 i izvaditi podatke' do
   subject.decode(REDAK_909).should == ["20121029", "00001", "000002", "", "909"]
 end

 it 'zna prepoznati redak 999 i izvaditi podatke' do
   subject.decode(REDAK_999).should == ["", "999"]
 end

 it 'zna prepoznati redak krive duljine' do
   lambda do
     subject.decode(REDAK_KRIVI)
   end.should raise_error "Duljina mora biti 1000 (dobio duljinu 999 - znakovno: '2503009NOVABANKA D.D. ZAGREB                             78427478595100020121029                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    900')"
 end

 it 'zna prepoznati krvi tip' do
  lambda do
    subject.decode(REDAK_KRIVI_TIP)
  end.should raise_error "Ne postoji slog tipa 901 koji je poslan"
 end

 it 'zna broj naloga' do
  subject.prometi(FINA_FILE).count.should == 2
 end

 ####################
 # format prometa
 ####################
 # broj izvoda
 # broj prometa u izvodu
 # datum izvoda
 # vrsta_transakcije
 # transakcijski_racun
 # valuta
 # racun_stranka
 # naziv stranka
 # adresa_stranka
 # mjesto_stranka
 # datum_valute
 # datum_izvrsenja
 # iznos
 # poziv_na_broj_platitelja
 # poziv_na_broj_primatelja
 # opis_prometa
 # identifikacijski_broj_prometa

 it 'zna podatke naloga' do
  subject.prometi(FINA_FILE)[0].should == [
                                            251,
                                            1,
                                            DateTime.parse('2012-10-27'),
                                            :u_korist,
                                            "HR2225030091100023273",
                                            "HRK",
                                            "25030091011111116", "KOMNY  D.O.O.", "DOMOVINSKOG RATA 72", "SPLIT",
                                            DateTime.parse('2012-10-27'),
                                            DateTime.parse('2012-10-27'),
                                            BigDecimal(530).round(2),
                                            "HR001010707032",
                                            "HR026026102012",
                                            "BONORA PARKING 26/10/2012",
                                            "20121027000022"
                                          ]

  subject.prometi(FINA_FILE)[1].should == [
                                            251,
                                            2,
                                            DateTime.parse('2012-10-27'),
                                            :na_teret,
                                            "HR2225030091100023273",
                                            "HRK",
                                            "25030091011111116", "KOMNY  D.O.O.", "DOMOVINSKOG RATA 72", "SPLIT",
                                            DateTime.parse('2012-10-27'),
                                            DateTime.parse('2012-10-27'),
                                            -1320.0,
                                            "HR001010487032",
                                            "HR02932610212",
                                            "POLOG",
                                            "20121027000097"
                                          ]
  end

end

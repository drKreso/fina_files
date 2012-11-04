#encoding:utf-8
require 'fina_files/zbrojni_nalog'

describe ZbrojniNalog do
  NALOZI = [
              [
                "HR68 8109-58913703560-1209",
                "MIO I STUP",
                "1001005-1863000160",
                "DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE",
                574.6
              ],
              [
                "HR68 2003-58913703560-1209",
                "MIO II STUP",
                "1001005-1700036001",
                "DOPRINOS ZA MIROVINSKO OSIGURANJE",
                191.53
              ]
           ]

  #201206111701                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         300
  it 'stavlja red 300' do
    subject.datum = DateTime.parse('2012-07-25')
    subject.nalozi = NALOZI
    subject.rows[0].should == ("201207251701" + " "*985 + "300")
    subject.rows[0].length.should ==  1000
  end

  it 'stavlja red 301' do
    subject.datum = DateTime.parse('2012-07-25')
    subject.nalozi = NALOZI
    subject.rows[1].should ==  "#{ZbrojniNalog::IBAN_platitelj}HRK" + " "*24 + "00002" + "00000000000000076613" + "20120725" + " "*916 + "301"
    subject.rows[1].length.should ==  1000
  end

  it 'stavlja red 309 prvi' do
    subject.datum = DateTime.parse('2012-07-25')
    subject.nalozi = NALOZI
    subject.rows[2].should == "1001005-1863000160" + " "*16 + "DRŽAVNI PRORAČUN REPUBLIKE HRVATSKE" + " "*35 + " "*103 +
                               "MIO I STUP" + " "*130 + "000000000057460" + "HR68" +  "8109-58913703560-1209 " + " "*159 + "0" + " "*449 + "309"
    subject.rows[2].length.should ==  1000
  end

  it 'stavlja red 309 drugi' do
    subject.datum = DateTime.parse('2012-07-25')
    subject.nalozi = NALOZI
    subject.rows[3].should == "1001005-1700036001                DOPRINOS ZA MIROVINSKO OSIGURANJE                                                                                                                                            MIO II STUP                                                                                                                                 000000000019153HR682003-58913703560-1209                                                                                                                                                                0                                                                                                                                                                                                                                                                                                                                                                                                                                                                 309"

    subject.rows[3].length.should == 1000
  end

  it 'stavlja na kraj red 399' do
    subject.nalozi = NALOZI
    subject.rows[-1].should == " "*997 + "399"
    subject.rows[-1].length.should == 1000
  end

end

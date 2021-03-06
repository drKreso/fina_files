require 'bigdecimal'

class ZbrojniNalogGenerator
  attr_accessor :datum, :nalozi
  attr_reader :rows, :iban_platitelj

  def initialize(iban_platitelj)
    @rows = []
    @nalozi = []
    @datum = DateTime.now
    @iban_platitelj = iban_platitelj
  end

  def rows
    @rows << row_300
    @rows << row_301
    @nalozi.each { |nalog| @rows << row_309(nalog) }
    @rows << row_399
  end

  def row_300
    datum.strftime('%Y%m%d') + "1701" + " "*985 + "300"
  end

  def row_301
    "#{@iban_platitelj}HRK" + " "*24 +  "%05d" % nalozi.count + zbroj_to_s + datum.strftime('%Y%m%d') + " "*916 + "301"
  end

  def row_309(nalog)
   nalog[3].ljust(34) + nalog[4].ljust(70) + " "*73 + nalog[0].gsub(" ","").ljust(26) + " "*4 +  nalog[2].ljust(140) +("%016.2f" % nalog[5]).gsub(".","") + nalog[1].gsub(" ","").ljust(26) + " "*159 + "0" + " "*449 + "309"
  end

  def zbroj_to_s
   raise 'nema naloga' if nalozi.count == 0
   amount = nalozi.map do |nalog|
      BigDecimal.new(nalog[5].to_s).round(2)
    end.reduce(:+)
    ("%021.2f" % amount).gsub(".","")
  end

  def row_399
    " "*997 + "399"
  end

  def export(file_name)
    File.open(File.expand_path(file_name), 'w:Windows-1250') do |file|
     rows.each do |row|
       encoded = (row + "\r\n").force_encoding("Windows-1250")
       file.write(encoded)
     end
   end
  end
end

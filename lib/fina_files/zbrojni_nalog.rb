require 'bigdecimal'

class ZbrojniNalog
  attr_accessor :datum, :nalozi
  attr_reader :rows
  IBAN_platitelj = 'HR1111111111111111111'

  def initialize
    @rows = []
    @nalozi = []
    @datum = DateTime.now
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
    "#{IBAN_platitelj}HRK" + " "*24 +  "%05d" % nalozi.count + zbroj_to_s + datum.strftime('%Y%m%d') + " "*916 + "301"
  end

  def row_309(nalog)
   nalog[2].ljust(34) + nalog[3].ljust(70) + " "*103 + nalog[1].ljust(140) +("%016.2f" % nalog[4]).gsub(".","") + nalog[0].gsub(" ","").ljust(26) + " "*159 + "0" + " "*449 + "309"
  end

  def zbroj_to_s
   raise 'nema naloga' if nalozi.count == 0
   amount = nalozi.map do |nalog|
      BigDecimal.new(nalog[4].to_s).round(2)
    end.reduce(:+)
    ("%021.2f" % amount).gsub(".","")
  end

  def row_399
    " "*997 + "399"
  end
end

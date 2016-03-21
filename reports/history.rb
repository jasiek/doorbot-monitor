require 'date'
require 'time'

class History
  def initialize(carddb, csv)
    @csv = csv
    @carddb = carddb
    @template = Haml::Engine.new(File.read('templates/history.haml'))
  end

  def run
    File.open('output/history.html', 'w') do |f|
      prepare_binding
      f << @template.render(binding)
    end
  end

  def prepare_binding
    @a_week_ago = Date.today - 7
    @bucket = {}
    @csv.reverse.each do |(time, card, port)|
      time = Time.parse(time)
      date = time.to_date
      break if date < @a_week_ago
      @bucket[date] ||= []
      @bucket[date] << [time, @carddb.id_for_card(card), @carddb.nick_for_card(card)]
    end
  end
end

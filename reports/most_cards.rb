class MostCards
  def initialize(carddb)
    @carddb = carddb
    @template = Haml::Engine.new(File.read('templates/most_cards.haml'))
  end

  def run
    File.open('output/most_cards.html', 'w') do |f|
      prepare_binding
      f << @template.render(binding)
    end
  end

  def prepare_binding
    @bucket = @carddb.cards_by_id.map do |id, cards|
      [@carddb.nick_for_id(id), cards.count]
    end.sort_by do |a|
      - a.last
    end
  end
end

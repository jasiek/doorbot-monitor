class TopCards
  def initialize(csv)
    @csv = csv
    @template = Haml::Engine.new(File.read('templates/top_cards.haml'))
  end

  def run
    File.open('output/top_cards.html', 'w') do |f|
      prepare_binding
      f << @template.render(binding)
    end
  end

  def prepare_binding
    @bucket = Hash.new 0
    @csv.each do |(_, card)|
      @bucket[card] += 1
    end
    @bucket = @bucket.to_a.sort_by do |a|
      -a.last
    end
  end
end

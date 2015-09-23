class TopUsers
  def initialize(carddb, csv)
    @csv = csv
    @carddb = carddb
    @template = Haml::Engine.new(File.read('templates/top_users.haml'))
  end

  def run
    File.open('output/top_users.html', 'w') do |f|
      prepare_binding
      f << @template.render(binding)
    end
  end

  def prepare_binding
    @bucket = Hash.new 0
    @csv.each do |(_, card)|
      @bucket[@carddb.nick_for_card(card)] += 1
    end
    @bucket.to_a.sort_by do |a|
      -a.last
    end
  end
end

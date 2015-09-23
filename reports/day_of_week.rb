class DayOfWeek
  def initialize(csv)
    @csv = csv
    @template = Haml::Engine.new(File.read('templates/day_of_week.haml'))
  end

  def run
    File.open('output/day_of_week.html', 'w') do |f|
      prepare_binding
      f << @template.render(binding)
    end
  end

  def prepare_binding
    @bucket = Hash.new 0
    @csv.each do |(date_string, _)|
      @bucket[Time.parse(date_string).strftime("%A")] += 1
    end
    @bucket
  end
end

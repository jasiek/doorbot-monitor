class WeeklyMatrix
  def initialize(csv)
    @csv = csv
    @template = Haml::Engine.new(File.read('templates/weekly_matrix.haml'))
  end

  def run
    File.open('output/weekly_matrix.html', 'w') do |f|
      prepare_binding
      f << @template.render(binding)
    end      
  end

  def prepare_binding
    @matrix = Hash.new { |h, k| h[k] = Array.new(24, 0) }
    @csv.each do |(date_string, _)|
      time = Time.parse(date_string)
      weekday = time.strftime("%A")
      @matrix[weekday][time.hour] += 1
    end
  end
end

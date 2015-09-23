require 'csv'

logfile = 'logfile.csv'

raise "file exists" if File.exists?(logfile)

CSV.open('logfile.csv', 'w') do |csv|
  100_000.times.map do |i|
    [Time.now + rand(24 * 60 * 60 * 120), (('A'...'F').to_a + ('0'...'9').to_a).shuffle.take(10).join]
  end.sort_by do |a|
    a.first
  end.each do |row|
    csv << row
  end
end

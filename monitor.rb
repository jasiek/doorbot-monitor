require 'socket'
require 'csv'
require 'fileutils'
require 'net/http'
require 'cgi'
require 'pp'

class CSVRecorder
  def initialize(filename)
    @filename = filename
  end

  def notify(port, event, id)
    if event == 'RFID'
      CSV.open(@filename, "a") do |csv|
        csv << [Time.now, id, port]
        csv.fsync
      end
    end
  end
end

class Snapshotter
  CAMERA_URL = URI('https://london.hackspace.org.uk/members/camera.php?id=3')
  
  def initialize(directory)
    FileUtils.mkdir_p(@directory = directory)
    @cookie = CGI::Cookie.new('PHPSESSID', File.read('session.key'))
  end

  def notify(port, event, id)
    if event == 'RFID' && port == 50002
      filename = Time.now.strftime("%Y-%m-%d_%H:%M_#{id}.jpg")
      http = Net::HTTP.new(CAMERA_URL.host, CAMERA_URL.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(CAMERA_URL.request_uri)
      request['Cookie'] = @cookie.to_s
      response = http.request(request)

      if response.code == '200'
        File.open(File.join(@directory, filename), 'w') do |f|
          f.write(response.body)
        end
      end
    end
  end
end

class DoorbotMonitor
  def initialize(ports)
    @ports = ports
  end

  def listen(*listeners)
    sockets = @ports.map { |p| UDPSocket.new(Socket::AF_INET).tap { |u| u.bind("0.0.0.0", p) } }
    loop do
      socks, _ = IO.select(sockets)
      socks.each do |sock|
        _, port, _, _ = sock.addr
        message, _ = sock.recvfrom(255)
        event, id, _ = message.split("\n")
        listeners.each do |listener|
          listener.notify(port, event, id)
        end
      end
    end
  end
end

if __FILE__ == $0
  DoorbotMonitor.new([50000, 50002]).listen(CSVRecorder.new("logfile.csv"), Snapshotter.new('snaps'))
end

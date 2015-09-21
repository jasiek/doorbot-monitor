require 'socket'
require 'csv'

class DoorbotMonitor
  def initialize(ports)
    @ports = ports
    @csv = CSV.open("logfile.csv", "a")
  end

  def listen(&blk)
    sockets = @ports.map { |p| UDPSocket.new(Socket::AF_INET).tap { |u| u.bind("0.0.0.0", p) } }
    loop do
      socks, _ = IO.select(sockets)
      socks.each do |sock|
        message, _ = sock.recvfrom(255)
        event, id, _ = message.split("\n")
        if event == 'RFID'
          @csv << [Time.now, id]
          @csv.fsync
        end
      end
    end
  end
end

if __FILE__ == $0
  DoorbotMonitor.new([50000, 50002]).listen
end

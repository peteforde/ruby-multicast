require "socket"
require "ipaddr"

MULTICAST_ADDR = "224.0.0.1"
BIND_ADDR = "0.0.0.0"
PORT = 3000

socket = UDPSocket.new
membership = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton

socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership)
begin
  socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)
rescue SocketError
  puts "SO_REUSEPORT not supported on this architecture"
end

socket.bind(BIND_ADDR, PORT)

loop do
  message, _ = socket.recvfrom(255)
  puts message
end
require 'socket'
require 'uri'

class HTTP_server
  def initialize(handler, path)
    @handler = handler
    @path = path
    @server = TCPServer.open(8000)
  end

  def start
    loop do
      Thread.start(@server.accept) do |client|
        request = client.gets
        @handler.new(request, client, @path)
        socket.close
      end
    end
  end
end

require 'socket'
require 'uri'
class HTTP_Handler
  def initialize(request, client, path)
    request_parts = request.split(' ')
    @method = request_parts[0]
    @uri = request_parts[1]
    @version = request_parts[2]
    @client = client
    @path = path
    log(request)

    case @method
      when 'GET'
        do_get(@uri)
      when 'HEAD'
        do_head
      when 'POST'
        do_post
      when 'OPTIONS'
        do_delete
      else
        log("INVALID REQUEST #{request}!")
    end
  end

  def do_get(path)
    local_path = to_local_path(path)
    local_path = to_local_path('/index.html') if path == '/'
    File.file?(local_path)
    if File.file?(local_path)
      file = File.open(local_path)
      @client.print "HTTP/1.1 200 OK\r\n" +
                       "Content-Type: #{type(local_path)}\r\n" +
                       "Content-Length: #{file.size}\r\n" +
                       "Connection: close\r\n"
      @client.print "\r\n"
      IO.copy_stream(local_path, @client)
    elsif Dir.exist?(local_path)
    else
      error(404, "File not found\n")
    end
  end

  def do_head

  end

  def do_post

  end

  def do_options

  end
  
  def to_local_path(path)
    (@path + '/web' + URI.unescape(path)).gsub('../', '')
  end

  def type(path)
    extensions  = {
        'html'  => 'text/html',
        'css'   => 'text/css',
        'js'    => 'tex/js',
        'dart'  => 'text/js',
        'txt'   => 'text/plain',
    }
    default = 'application/octet-stream'
    extension = path.split('.').last
    extension = extensions[extension]
    extension ||= default
    extension
  end

  def error(code, msg)
    @client.print "HTTP/1.1 #{code} Not Found\r\n" +
                      "Content-Type: text/plain\r\n" +
                      "Content-Length: #{msg.size}\r\n" +
                      "Connection: close\r\n"
    @client.print "\r\n"
    @client.print(msg)
  end

  def log(str)
    log_file = File.new("#{@path}/server.log", 'a')
    log_file.syswrite("[#{Time.new}]\t\"#{str.chomp}\"\n")
    log_file.close
  end
end

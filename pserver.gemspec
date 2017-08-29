Gem::Specification.new do |s|
  s.name        = 'pServer'
  s.version     = '0.0.0'
  s.executables << 'pserver'
  s.date        = '2017-08-23'
  s.summary     = "a simple HTTP server"
  s.description = "a simple HTTP server"
  s.authors     = ["Ellis W.R. Sutko"]
  s.email       = 'esutko@gmail.com'
  s.files       = ["lib/pserver.rb", "lib/pserver/http_server.rb",
                  "lib/pserver/http_handler.rb"]
  s.license       = 'MIT'
end

use Rack::Static,
  url: ["/js", "/css"],
  root: "/public"

run lambda { |env|
  [200, 
  {'Content-Type' => 'text/html', 'Cache-Control' => 'public, max-age=86400' },
  File.open('public/home.html', File::RDONLY)]
} 

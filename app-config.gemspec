require 'lib/app-config/version'

Gem::Specification.new do |s|
  s.name = "app-config"
  s.version = AppConfig::VERSION
  s.date = Time.now.strftime("%Y-%m-%d")
  s.summary = "Configurable application settings"
  s.description = "Flexible and simple configuration settings for your Rails/Sinatra applications"
  s.authors = ["Dan Sosedoff"]
  s.email = "dan.sosedoff@gmail.com"
  s.homepage = "http://github.com/sosedoff/app-config"
  s.license = "MIT"

  s.files = %w[
    lib/app-config.rb
    lib/app-config/version.rb
    lib/app-config/errors.rb
    lib/app-config/processor.rb
    lib/app-config/app-config.rb
  ]

  s.add_dependency('activerecord', '>= 3.0.0')

  s.has_rdoc = true
  s.rubygems_version = '1.3.7'
end
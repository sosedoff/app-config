require File.expand_path('../lib/app-config/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "app-config"
  s.version     = AppConfig::VERSION.dup
  s.summary     = "Configurable application settings"
  s.description = "Flexible and simple configuration settings for your Rails/Sinatra applications."
  s.homepage    = "http://github.com/sosedoff/app-config"
  s.authors     = ["Dan Sosedoff"]
  s.email       = ["dan.sosedoff@gmail.com"]
  s.license     = "MIT"
  
  s.add_development_dependency 'rake', '~> 0.8'
  s.add_development_dependency 'rspec', '~> 2.6'
  s.add_development_dependency 'simplecov', '~> 0.4'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  
  s.add_runtime_dependency     'activerecord', '~> 3.0'
  
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.require_paths = ["lib"]
  
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
end
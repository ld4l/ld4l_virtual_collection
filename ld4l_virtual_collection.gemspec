$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ld4l_virtual_collection/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ld4l_virtual_collection"
  s.version     = Ld4lVirtualCollection::VERSION
  s.authors     = ["E. Lynette Rayle"]
  s.email       = ["elr37@cornell.edu"]
  s.homepage    = "https://github.com/elrayle/ld4l_virtual_collection"
  s.summary     = "Rails engine for Virtual Collection UI"
  s.description = "Rails engine for Virtual Collection UI"
  s.license     = "APACHE2"
  s.required_ruby_version     = '>= 1.9.3'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"

  s.add_development_dependency "sqlite3"
end

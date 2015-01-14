$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ld4l_virtual_collection/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ld4l_virtual_collection"
  s.version     = Ld4lVirtualCollection::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Ld4lVirtualCollection."
  s.description = "TODO: Description of Ld4lVirtualCollection."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"

  s.add_development_dependency "sqlite3"
end

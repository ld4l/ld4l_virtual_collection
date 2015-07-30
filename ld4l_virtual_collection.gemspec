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

  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency 'sass-rails',   '~> 4.0'

  s.add_development_dependency "sqlite3"

  s.add_dependency('rdf', '~> 1.1')
  s.add_dependency('active-triples', '0.6.1')
  s.add_dependency('active_triples-local_name')
  s.add_dependency('ld4l-ore_rdf', '~> 0.0')
  s.add_dependency('ld4l-open_annotation_rdf', '~> 0.0')
  s.add_dependency('ld4l-foaf_rdf', '~> 0.0')
  s.add_dependency('doubly_linked_list', '~> 0.0')


  s.add_dependency "jquery-rails"
  s.add_dependency "bootstrap-sass"
  # s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'font-awesome-rails'



  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  s.add_dependency 'turbolinks'

  s.add_development_dependency('pry')
  # s.add_development_dependency('pry-byebug')    # Works with ruby > 2
  # s.add_development_dependency('pry-debugger')  # Works with ruby < 2
  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_development_dependency('coveralls')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('webmock')

end

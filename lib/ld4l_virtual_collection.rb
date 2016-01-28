require 'rails'
require 'rdf'
require 'active_triples'
require 'active_triples/local_name'
require	'linkeddata'
require 'ld4l/foaf_rdf'
require 'ld4l/ore_rdf'
require 'ld4l/open_annotation_rdf'
require "ld4l_virtual_collection/engine"
require 'ld4l_virtual_collection/configuration'
require 'jquery-rails'
require 'turbolinks'
require 'bootstrap-sass'


module Ld4lVirtualCollection
  class Engine < ::Rails::Engine

    isolate_namespace Ld4lVirtualCollection

    # -----------------------------------------
    #  Default configurations
    # -----------------------------------------
    # triplestore configuration
    config.triplestore = ActiveSupport::OrderedOptions.new
    config.triplestore.default_repository = 'sqlite3:db/vc_triplestore.sqlite3'

    # URI generation configuration
    config.urigenerator = ActiveSupport::OrderedOptions.new
    config.urigenerator.base_uri               = 'http://localhost/triples-dev/'
    config.urigenerator.bibliographic_base_uri = 'http://localhost/bibref/'
    config.urigenerator.person_base_uri        = 'http://localhost/individual/'
  end

end

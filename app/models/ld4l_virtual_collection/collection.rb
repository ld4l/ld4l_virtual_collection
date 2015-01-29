require 'ld4l/ore_rdf'

module Ld4lVirtualCollection
  class Collection < ActiveRecord::Base

    def self.all
      LD4L::OreRDF::FindAggregations.call(
          :properties => { :title => RDF::DC.title, :description => RDF::DC.description } )
    end

    def self.new(*params)
      # puts("*** Entering MODEL: new")
      aggregation = LD4L::OreRDF::CreateAggregation.call
      aggregation.title       = params[0][:title]       if params && params.size > 0 && params[0].has_key?('title')
      aggregation.description = params[0][:description] if params && params.size > 0 && params[0].has_key?('description')
      aggregation
    end

    def self.update(*params)
      # puts("*** Entering MODEL: update")
      aggregation = LD4L::OreRDF::ResumeAggregation.call(params[0][:id])
      aggregation.title       = params[0][:title]       if params && params.size > 0 && params[0].has_key?('title')
      aggregation.description = params[0][:description] if params && params.size > 0 && params[0].has_key?('description')
      aggregation
    end

    def self.destroy
      # puts("*** Entering MODEL: destroy")

    end

    def self.find(uri)
      # puts("*** Entering MODEL: find")
      LD4L::OreRDF::ResumeAggregation.call(uri)
    end

  end
end

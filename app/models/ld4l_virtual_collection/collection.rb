require 'ld4l/ore_rdf'

module Ld4lVirtualCollection
  class Collection < ActiveRecord::Base

    def self.all
      LD4L::OreRDF::FindAggregations.call(
          :properties => { :title => RDF::DC.title, :description => RDF::DC.description } )
    end

    def self.new(*params)
      aggregation = LD4L::OreRDF::CreateAggregation.call
      aggregation.title       = params.title       if params && params.size > 0 && params[0].has_key?('title')
      aggregation.description = params.description if params && params.size > 0 && params[0].has_key?('description')
      aggregation
    end

    def self.update(aggregation, params)
      aggregation.title       = params.title       if params.has_key?('title')
      aggregation.description = params.description if params.has_key?('description')
      aggregation
    end

    def self.destroy

    end

    def self.find(uri)
      LD4L::OreRDF::ResumeAggregations.call(uri)
    end

  end
end

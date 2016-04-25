require 'ld4l/ore_rdf'

module Ld4lVirtualCollection
  class Item < ActiveRecord::Base

    def self.all(collection)
      LD4L::OreRDF::FindProxies.call(
          :aggregation => collection.id,
          :properties => { :proxy_for => RDFVocabularies::ORE.proxyFor, :description => RDF::DC.description } )
    end

    def self.new(collection, *params)
      # puts("*** Entering MODEL: new item")
      item_uri = params[0][:proxy_for].strip    if params && params.size > 0 && params[0].has_key?('proxy_for')
      if(item_uri && item_uri.start_with?("http://da-stg-ssolr.library.cornell.edu/solr/") )
        add_items_by_query(collection, item_uri)
      else
        (item_uri && item_uri.size > 0) ? LD4L::OreRDF::AddAggregatedResource.call( collection, item_uri ) :
                 LD4L::OreRDF::ProxyResource.new
    end
    end

    def self.update(collection, item, *params)
      # puts("*** Entering MODEL: update item")
      item_uri = params[0][:proxy_for]       if params && params.size > 0 && params[0].has_key?('proxy_for')
      item.set_value('proxy_for', item_uri)
      item
    end

    def self.destroy(collection,item)
      # puts("*** Entering MODEL: destroy item")

    end

    def self.find(uri)
      # puts("*** Entering MODEL: find item")
      LD4L::OreRDF::ProxyResource.new(uri)
    end


    # TODO XXX
    def self.add_items_by_query(collection, solr_query)
      # puts("### Entering MODEL: add_items_by_query #{solr_query}")
      metadata = LD4L::WorksRDF::GetMetadataFromSolrQuery.call(solr_query, nil)
      metadata.each do |m|
        LD4L::OreRDF::AddAggregatedResource.call(collection, m.uri)
      end
    end
  end
end

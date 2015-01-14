# Ld4lVirtualCollection

Rails Engine LD4L Virtual Collection provides a user interface for creating and manipulating Virtual Collections.


## Installation

Temporary get the gem from github until the gem is released publicly.

Add this line to your application's Gemfile:

<!--    gem 'ld4l_virtual_collection' -->
    gem 'ld4l_virtual_collection', '~> 0.0.1', :git => 'git@github.com:elrayle/ld4l_virtual_collection.git'
    

And then execute:

    $ bundle install

<!--
Or install it yourself as:

    $ gem install ld4l_virtual_collection
-->


## Usage

**Caveat:** This rails engine is part of the LD4L Project and is being used in that context.  There is no guarantee 
that the code will work in a usable way outside of its use in LD4L Use Cases.


### Configurations

TBA

<!--
* base_uri - base URI used when new resources are created (default="http://localhost/")
* localname_minter - minter function to use for creating unique local names (default=nil which uses default minter in active_triples-local_name gem)

*Setup for all examples.*

* Restart your interactive session (e.g. irb, pry).
* Use the Setup for all examples in main Examples section above.

*Example usage using configured base_uri and default localname_minter.*
```
LD4L::OpenAnnotationRDF.reset
LD4L::OpenAnnotationRDF.configure do |config|
  config.base_uri = "http://example.org/"
end

ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
              LD4L::OpenAnnotationRDF::CommentAnnotation, 10, {:prefix=>'ca'} ))

puts ca.dump :ttl

ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
              LD4L::OpenAnnotationRDF::CommentAnnotation, 10, {:prefix=>'ca'},
              &LD4L::OpenAnnotationRDF.configuration.localname_minter ))

puts ca.dump :ttl
```
NOTE: If base_uri is not used, you need to restart your interactive environment (e.g. irb, pry).  Once the 
  CommentAnnotation class is instantiated the first time, the base_uri for the class is set.  If you ran
  through the main Examples, the base_uri was set to the default base_uri.


*Example triples created for a person with configured base_uri and default minter.*
```
<http://example.org/ca45c9c85b-25af-4c52-96a4-cf0d8b70a768> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#commenting> .
```

*Example usage using configured base_uri and configured localname_minter.*
```
LD4L::OpenAnnotationRDF.configure do |config|
  config.base_uri = "http://example.org/"
  config.localname_minter = lambda { |prefix=""| prefix+'_configured_'+SecureRandom.uuid }
end

ca = LD4L::OpenAnnotationRDF::CommentAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
              LD4L::OpenAnnotationRDF::CommentAnnotation, 10, 'ca',
              &LD4L::OpenAnnotationRDF.configuration.localname_minter ))

puts ca.dump :ttl
```
NOTE: If base_uri is not used, you need to restart your interactive environment (e.g. irb, pry).  Once the 
  CommentAnnotation class is instantiated the first time, the base_uri for the class is set.  If you ran
  through the main Examples, the base_uri was set to the default base_uri.


*Example triples created for a person with configured base_uri and configured minter.*
```
<http://example.org/ca_configured_6498ba05-8b21-4e8c-b9d4-a6d5d2180966> a <http://www.w3.org/ns/oa#Annotation>;
   <http://www.w3.org/ns/oa#motivatedBy> <http://www.w3.org/ns/oa#commenting> .
```
-->

### Models

The Rails Engine VirtualCollectionUI uses the following ontology based gems:

1. LD4L::OreRDF
1. LD4L::OpenAnnotationRDF
1. LD4L::FoafRDF


### Ontologies

The listed ontologies are used to implement virtual collections and are brought into use by the ontology gems.
 
* [ORE](http://www.openarchives.org/ore/1.0/vocabulary)
* [OA](http://www.openannotation.org/spec/core/)
* [FOAF](http://xmlns.com/foaf/spec/)
* [RDF](http://www.w3.org/TR/rdf-syntax-grammar/)
* [Dublin Core (DC)](http://dublincore.org/documents/dces/)
* [Dublin Core Terms (DCTERMS)](http://dublincore.org/documents/dcmi-terms/)



## Contributing

1. Fork it ( https://github.com/[my-github-username]/ld4l-open_annotation_rdf/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

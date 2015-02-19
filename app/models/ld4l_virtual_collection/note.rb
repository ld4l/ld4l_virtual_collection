require 'ld4l/ore_rdf'

module Ld4lVirtualCollection
  class Note < ActiveRecord::Base

    def self.all(collection,item)
      notes = []
      item_uri = item.id
      all_annotations_uris = LD4L::OpenAnnotationRDF::Annotation.find_by_target(item_uri)
      all_annotations_uris.each do |uri|
        anno = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        notes << anno  if anno.kind_of?(LD4L::OpenAnnotationRDF::CommentAnnotation)
      end
      notes
    end

    def self.new(collection,item,*params)
      # puts("*** Entering MODEL: new note")
      item_uri = item.id
      item_uri = RDF::URI(item_uri)  unless item_uri.kind_of?(RDF::URI)
      note = LD4L::OpenAnnotationRDF::CommentAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
                      LD4L::OpenAnnotationRDF::CommentAnnotation, 5, {:prefix=>'n'} ))
      note.hasTarget = item_uri
      note.setComment("")                    unless params && params.size > 0 && params[0][:new_value]
      note.setComment(params[0][:new_value]) if     params && params.size > 0 && params[0][:new_value]
      # note.annotatedBy = p
      note.setAnnotatedAtNow
      note
    end

    def self.update(note,*params)
      # puts("*** Entering MODEL: update note")
      item_uri = params.first[:item_id]
      item_uri = RDF::URI(item_uri)  unless item_uri.kind_of?(RDF::URI)
      note.hasTarget = item_uri
      comment = params.first[:new_value]
      note.setComment(comment)
      note.setAnnotatedAtNow
      # note.annotatedBy = p
      note
    end

    def self.destroy(note)
      # puts("*** Entering MODEL: destroy note")

    end

    def self.find(uri)
      # puts("*** Entering MODEL: find note")
      LD4L::OpenAnnotationRDF::CommentAnnotation.new(uri)
    end

  end
end

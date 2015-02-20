module Ld4lVirtualCollection
  class Tag < ActiveRecord::Base

    def self.all(collection,item)
puts("*** Entering MODEL: all tags")
      self.all_hash(item).to_a
    end

    def self.all_hash(target)
puts("*** Entering MODEL: all tags as hash")
      tags = {}
      target_uri = target.id
      all_annotations_uris = LD4L::OpenAnnotationRDF::Annotation.find_by_target(target_uri)
      all_annotations_uris.each do |uri|
        anno = LD4L::OpenAnnotationRDF::Annotation.resume(uri)
        tags[anno.getTag] = anno    if anno.kind_of?(LD4L::OpenAnnotationRDF::TagAnnotation)
      end
      tags
    end

    def self.all_values(target)
puts("*** Entering MODEL: values for all tags")
      self.all_hash(target).keys.join("; ")
    end

    def self.update_all(target,*params)
puts("*** Entering MODEL: update_all tags")
      all_anno_hash = self.all_hash(target)

      # puts("*** Entering MODEL: update_all tags")
      target_uri = target.id
      target_uri = RDF::URI(target_uri)  unless target_uri.kind_of?(RDF::URI)

      old_tags = params.first[:old_tags]
      new_tags = params.first[:new_tags]

      old_tags = old_tags.split(";").collect { |tag_value| tag_value.strip }
      new_tags = new_tags.split(";").collect { |tag_value| tag_value.strip }

      delete_list = []
      add_list    = []
      old_tags.each { |tag_value| delete_list << tag_value  unless new_tags.include? tag_value }
      new_tags.each { |tag_value| add_list    << tag_value  unless old_tags.include? tag_value }

      delete_list.collect! { |tag_value| all_anno_hash[tag_value] }
      add_list.collect! do |tag_value|
        tag = LD4L::OpenAnnotationRDF::TagAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
                      LD4L::OpenAnnotationRDF::TagAnnotation, 5, {:prefix=>'n'} ))
        tag.hasTarget = target_uri
        tag.setTag(tag_value)
        tag.setAnnotatedAtNow
        # tag.annotatedBy = p
        tag
      end
      { :delete_list => delete_list, :add_list => add_list }
    end

    def self.new(collection,item,*params)
      puts("*** Entering MODEL: new tag")
      item_uri = item.id
      item_uri = RDF::URI(item_uri)  unless item_uri.kind_of?(RDF::URI)
      tag = LD4L::OpenAnnotationRDF::TagAnnotation.new(ActiveTriples::LocalName::Minter.generate_local_name(
                                                               LD4L::OpenAnnotationRDF::TagAnnotation, 5, {:prefix=>'n'} ))
      tag.hasTarget = item_uri
      tag_value = params.first[:new_value] if params && params.size > 0 && params.has_key?(:new_value)
      tag.setTag(tag_value)  if tag_value
      tag.setAnnotatedAtNow
      # tag.annotatedBy = p
      tag
    end


    def self.update(tag,*params)
      puts("*** Entering MODEL: update tag")
      item_uri = params.first[:item_id]
      item_uri = RDF::URI(item_uri)  unless item_uri.kind_of?(RDF::URI)
      tag.hasTarget = item_uri
      tag_value = params.first[:new_value]
      tag.setTag(tag_value)
      tag.setAnnotatedAtNow
      # tag.annotatedBy = p
      tag
    end

    def self.destroy(tag)
      puts("*** Entering MODEL: destroy tag")

    end

    def self.find(uri)
      puts("*** Entering MODEL: find tag")
      LD4L::OpenAnnotationRDF::TagAnnotation.new(uri)
    end

  end
end

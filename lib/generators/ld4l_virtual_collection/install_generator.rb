require 'rails/generators'
require 'rails/generators/migration'

module LD4L::VirtualCollections
  class Install < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    argument :model_name, type: :string, default: "user"
    desc """
  This generator makes the following changes to your application:
   1. Adds controller behavior to the application controller
   2. Copies the catalog controller into the local app
   3. Adds LD4L::VirtualCollection::SolrDocumentBehavior to app/models/solr_document.rb
   4. Installs Blacklight gallery (optional - commented out)
         """

    def run_required_generators
      say_status("info", "GENERATING BLACKLIGHT", :blue)
      generate "blacklight:install --devise"
    end

    def banner
      say_status("info", "GENERATING LD4L VIRTUAL COLLECTIONS", :blue)
    end

    def catalog_controller
      copy_file "catalog_controller.rb", "app/controllers/catalog_controller.rb"
    end

    def copy_helper
      copy_file 'ld4l_virtual_collection_helper.rb', 'app/helpers/ld4l_virtual_collection_helper.rb'
    end

    # def remove_blacklight_scss
    #   remove_file 'app/assets/stylesheets/blacklight.css.scss'
    # end
    #
    # def add_ld4l_virtual_collections_assets
    #   insert_into_file 'app/assets/stylesheets/application.css', after: ' *= require_self' do
    #     "\n *= require ld4l_virtual_collections"
    #   end
    #
    #   gsub_file 'app/assets/javascripts/application.js',
    #             '//= require_tree .', '//= require ld4l_virtual_collections'
    # end
    #
    # def tinymce_config
    #   copy_file "config/tinymce.yml", "config/tinymce.yml"
    # end
    #
    # # The engine routes have to come after the devise routes so that /users/sign_in will work
    # def inject_routes
    #   gsub_file 'config/routes.rb', /root (:to =>|to:) "catalog#index"/, ''
    #
    #   routing_code = "\n  Hydra::BatchEdit.add_routes(self)\n" \
    #     "  # This must be the very last route in the file because it has a catch-all route for 404 errors.
    # # This behavior seems to show up only in production mode.
    # mount Sufia::Engine => '/'\n  root to: 'homepage#index'\n"
    #
    #   sentinel = /devise_for :users/
    #   inject_into_file 'config/routes.rb', routing_code, after: sentinel, verbose: false
    # end

    # Add behaviors to the SolrDocument model
    def inject_ld4l_virtual_collections_solr_document_behavior
      file_path = "app/models/solr_document.rb"
      if File.exist?(file_path)
        inject_into_file file_path, after: /include Blacklight::Solr::Document.*$/ do
          "\n  # Adds LD4L::VirtualCollections behaviors to the SolrDocument.\n" \
            "  include LD4L::VirtualCollections::SolrDocumentBehavior\n"
        end
      else
        puts "     \e[31mFailure\e[0m  LD4L Virtual Collections requires a SolrDocument object. This generator assumes that the model is defined in the file #{file_path}, which does not exist."
      end
    end

    # def install_blacklight_gallery
    #   generate "blacklight_gallery:install"
    # end
  end
end

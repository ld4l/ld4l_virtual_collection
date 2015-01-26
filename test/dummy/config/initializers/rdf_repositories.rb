def configure_repositories
  ActiveTriples::Repositories.clear_repositories!


  if Rails.env.development?
    # puts "*****************************************************************"
    # puts "   DEV ENV: Creating rdf-do :default ActiveTriples Repository -- #{Rails.configuration.triplestore.default_repository}"
    # puts "*****************************************************************"


    # FIXME: WARNING: This code isn't working as expected for DEV using rdf-do.  Need further investigation.
    # FIXME: The same code works fine when rails c is started with the add_repository line commented out of this
    # FIXME: initializer and typed in rails c explicitly verbatim.  This appears to be an error in rdf-do code
    # FIXME: that will not be debugged at this time.

    # FIXME: Type the following line into rails c with "sqlite3:db/triples.sqlite" in place of the configuration

    ActiveTriples::Repositories.add_repository :default, RDF::DataObjects::Repository.new(Rails.configuration.triplestore.default_repository)

    # puts "***  After add_repository ***"
  elsif Rails.env.test?
    ActiveTriples::Repositories.add_repository :default, RDF::Repository.new
  else
    # TODO Production TripleStore TBD -- Need to update once this is properly configured in config/environments/production.rb
    ActiveTriples::Repositories.add_repository :default, RDF::DataObjects::Repository.new(Rails.configuration.triplestore.default_repository)
  end
end
# Not sure why configure_repositories is called twice in this way.  Code modified from Oregon Digital project.
configure_repositories
Rails.application.config.to_prepare do
  configure_repositories
end

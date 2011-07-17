require 'rdf/sesame'
Spira.add_repository! :default, RDF::Sesame::Repository.new('http://localhost:888/openrdf-sesame/repositories/njs1')

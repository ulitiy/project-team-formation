class Competence
  include Spira::Resource
  type Vocabularies::Competence.Professional_Complex_Competence
  base_uri "http://example.com/competences/"
  property :name, :predicate=>Vocabularies::Competence.hasName, :type=>String

end
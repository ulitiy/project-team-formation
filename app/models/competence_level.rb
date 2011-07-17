class CompetenceLevel
  include Spira::Resource
  type Vocabularies::Competence.Competence_Level
  base_uri "http://example.com/cl/"
  property :value, :predicate=>Vocabularies::Competence.hasValue, :type=>Integer
  property :name, :predicate=>Vocabularies::Competence.hasName, :type=>String
end
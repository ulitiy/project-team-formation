class CompetenceWithLevel
  include Spira::Resource
  type Vocabularies::Competence.Complex_Competence_With_Level
  base_uri "http://example.com/ccwls/"
  property :level, :predicate=>Vocabularies::Competence.hasCompetenceLevel, :type=>:CompetenceLevel
  property :competence, :predicate=>Vocabularies::Competence.belongsToComplexCompetence, :type=>:Competence
end
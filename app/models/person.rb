class Person
  include Spira::Resource

  base_uri "http://example.org/people/"
  default_vocabulary Vocabularies::Staff
  # здесь записывается адрес RDF схемы или онтологии к которой приписываются
  # предикаты. А вообще лучше зарегистрировать свои словари здесь и обращаться к ним как к FOAF
  type FOAF.Person
  property :name, :predicate => FOAF.name, :type => String
  property :age,  :predicate => FOAF.age,  :type => Integer
  property :mbox, :predicate => FOAF.mbox, :type=>URI #по сути - это ресурс, но этот параметр на самом деле мало значит, т.к.
                                                      #в БЗ все одинаково сериализуется. Но сериализация в файлы будет валидной.
  #property :has_role, :type=>:role
  property :account_id, :type=>String
  has_many :competences_with_level, :type=>:CompetenceWithLevel, :predicate=>Vocabularies::Staff.hasCompetence

  def account
    Account.find account_id
  end

#упрощение присвоения email
  def email= email
    self.mbox=RDF::URI "mailto:#{email}"
  end

  def email
    mbox.to_s.gsub "mailto:", ""
  end

  #добавление компетенции человека
  def add_competence! comp, lev
    ccwl=CompetenceWithLevel.create :competence=>comp, :level=>lev
    self.competences_with_level << ccwl
    self.save
  end

  def remove_competence! ccwl
    self.competences_with_level=self.competences_with_level.to_a
    self.competences_with_level.delete ccwl
    self.save
    ccwl.destroy
  end

end


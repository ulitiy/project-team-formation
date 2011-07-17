class Task
  include Spira::Resource

  type Vocabularies::Project.Task
  base_uri "http://example.org/tasks/"
  default_vocabulary Vocabularies::Project

  property :name, :predicate=>Vocabularies::Project.hasName, :type=>String
  property :project, :predicate=>Vocabularies::Project.belongsToProject, :type=>:Project
  has_many :competences_with_level, :predicate=>Vocabularies::Project.requires, :type=>:CompetenceWithLevel

  def find_candidates
    sel=Person._where
    i=0
    competences_with_level.each do |cwl|
      cwl_id=:"cwl#{i}" #задаем идентификатор ксу
      lev_id=:"lev#{i}"
      val=:"val#{i}"
      sel._where(:competences_with_level=>cwl_id) #человек должен иметь ксу
      sel.where([cwl_id,CompetenceWithLevel.properties[:competence][:predicate],cwl.competence.subject]) #с данной компетенцией
      sel.where([cwl_id,CompetenceWithLevel.properties[:level][:predicate],lev_id]) #с уровнем
      sel.where([lev_id,CompetenceLevel.properties[:value][:predicate],val]) #который имеет значение
      sel.filter("?val#{i} >= #{cwl.level.value}") #которое выше или равно тому, что требуется для данной задачи
      i+=1
    end
    sel.instances
  end

  #инициализируем симметричное отношение при создании
  def after_create
    self.project.tasks << self
    self.project.save
  end

  #при удалении
  def before_destroy
    p=self.project
    return true if p.nil?
    p.tasks.delete self
    p.save
    #удаляем зависимые требуемые уровни компетенций
    self.competences_with_level.each do |ccwl|
      ccwl.destroy
    end
  end

  #добавление требуемой для задачи компетенции
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
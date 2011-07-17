class Project
#осн. параметры см. в модели Person
  include Spira::Resource
  base_uri "http://example.com/projects/"
  default_vocabulary RDF::DOAP
  type RDF::DOAP.Project
  property :name, :type=>String
  property :vendor, :type=>String
  property :homepage, :type=>URI
  property :created, :type=>String
  property :description, :type=>String
  has_many :maintainers, :predicate=>RDF::DOAP.maintainer, :type=>:Person
  has_many :tasks, :predicate=>Vocabularies::Project.consistsOfTasks, :type=>:Task
  #выставляем дату создания
  def before_create
    self.created=Date.today.to_s
  end
  #контроль целостности при удалении. Руби-стайл
  def before_destroy
    self.tasks.each do |task|
      task.destroy
    end
  end
end


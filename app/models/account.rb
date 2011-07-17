class Account
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  field :person_uri

  def person
    @person||=Person.find person_uri #кэшируем для простого доступа при сохранении
  end

  after_create :create_person
  #создаем связку между аккаунтом и человеком (объект MongoDB и RDF-ресурс соответственно)
  def create_person
    person=Person.create! :account_id=>id.to_s, :mbox=>"mailto:#{email}"
    write_attributes :person_uri=>person.id
  end

end


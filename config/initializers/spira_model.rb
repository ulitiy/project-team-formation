#дописываем ORM
module Spira

#получаем эндпойнт
  def self.sparql
    @sparql_client||=SPARQL::Client.new('http://localhost:8080/openrdf-sesame/repositories/njs1?queryLn=SPARQL')
  end

#определяем методы класса модели
  module Resource
    extend ActiveModel::Naming
    module ClassMethods

#без инстенциализации
      def _where(*args)
        options = args.extract_options!

        sel=Spira.sparql.select(:s)
        sel.instance_class=self
        sel._where options
      end

#с инстенциализацией. Сокращенная нотация
      def where(*args)#могут быть опции, а может и нет.
        _where(args.extract_options!).instances
      end

#все сущности данного класса - обёртка поисковой функции
      alias all where

#первая сущность - для ORM адаптера и консоли. Оптимизирована для экономии ресурсов. Сокращенная нотация.
      def first(*args)
        sel=_where(args.extract_options!).limit(1).instances.first
      end

#последняя сущность
      def last(*args)
        self._where(args.extract_options!).order("DESC(?s)").limit(1).instances.first
      end

      def create!(*args)
        params=args.extract_options!
        lock
          @item=new_subject #без коллизий. Локи на уровне коллекции (RDF класса).
          @item.update(params)
          @item=@item.save!
        unlock
        @item
      end

      #то же самое, но без исключения
      def create(*args)
        params=args.extract_options!
        lock
          @item=new_subject
          @item.update(params)
          @item=@item.save
        unlock
        @item
      end

      #создается новый индивидуал с URI
      def new_subject
        self[next_id]
      end

      def lock #критическая секция идентифицирующаяся для данной модели
        @cs=CriticalSection.new self.name
        @cs.start
      end


      def unlock
        @cs.finish
      end

      #следующий id с учетом возможного удаления средних id
      def next_id
        #l=last
        #l ? l.id + 1 : 1
        Time.now.to_i.to_s+(rand*1000).to_i.to_s
      end

      #возврат ресурса по айдишнику
      def find id
        item=self[id]
        if item.exists?
          return item
        else
          raise Spira::NotFoundError, 'Item not found!'
        end
      end

      alias find! find #если вдруг перепутаю

#симуляция ActiveModel
      def model_name
        @model_name||=ActiveModel::Name.new self
      end
    end


#идентификатор сущности - возвращаем только правый кусок. Ну тут кому как нравится.
    module InstanceMethods
      def id
        if node?
          nil #обязательно, т.к. при создании формы запрашивается id и форма указывает на ноду
        else
          subject.to_s.sub(self.class.base_uri, "").to_i
        end
      end

#функция для url-helpera
      def to_param
        id.to_s
      end

#преобразование к триплетам
      def to_nt *args
        options=args.extract_options!
        except=options[:except].to_a
        RDF::NTriples::Writer.buffer do |writer|
          self.each do |statement|
            writer << statement if !except.member?(statement.predicate.qname.last)
          end
        end
      end

#возвращаем субъект
      def to_key
        if exists?
          return [id]
        else
          return nil
        end
      end

      def save #без восклицательного знака и исключений (скопировано с оригинала)
        existed = (self.respond_to?(:before_create) || self.respond_to?(:after_create)) && !self.type.nil? && exists?
        before_create if self.respond_to?(:before_create) && !self.type.nil? && !existed
        before_save if self.respond_to?(:before_save)
        case validate
          when true
            _update!
          when false
            return false
        end
        after_create if self.respond_to?(:after_create) && !self.type.nil? && !existed
        after_save if self.respond_to?(:after_save)
        self
      end

      def attribute_set(name, value)
        name=name.to_sym
        @dirty[name] = true
        @attributes[:current][name] = value
      end
      #для url_for
      def persisted?
        !id.nil?
      end

      alias destroy destroy!

    end
  end
end


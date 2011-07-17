#данный класс необходим для использования его в системе аутентификации Devise в качестве обёртки ORM
module Spira

  module Resource
    module ClassMethods
      include OrmAdapter::ToAdapter
    end

    class OrmAdapter < ::OrmAdapter::Base
      # Do not consider these to be part of the class list
      def self.except_classes
        @@except_classes ||= ["Spira::Base"]
      end

      # Gets a list of the available models for this adapter
      def self.model_classes
        ObjectSpace.each_object(Class).to_a.select {|klass| klass.ancestors.include? Spira::Resource &&
          !except_classes.include?(klass.name)}
        #так же сюда стоит добавить наследников Spira::Base
      end

      # get a list of column names for a given class
      def column_names
        klass.properties.keys
      end

      # @see OrmAdapter::Base#get!
      def get!(id)
        klass.find! wrap_key(id)
      end

      # @see OrmAdapter::Base#get
      def get(id)
        klass.find wrap_key(id)
      end

      # @see OrmAdapter::Base#find_first
      def find_first(options)
        klass.first options
      end

      # @see OrmAdapter::Base#find_all
      def find_all(options)
        klass.where options
      end

      # @see OrmAdapter::Base#create!
      def create!(attributes)
        item=klass.create!(attributes)
      end

    end
  end
end


module Devise
  module Orm
    module Spira
      module Hook
        def devise_modules_hook!
          extend Schema
          yield
          return unless Devise.apply_schema
          devise_modules.each { |m| send(m) if respond_to?(m, true) }
        end
      end

      module Schema
        include Devise::Schema

        # Tell how to apply schema methods
        def apply_devise_schema(name, type, options={})
          type = Spira::Types::Any #if type == DateTime
          property name, { :type => type }.merge!(options)
        end
      end
    end
  end
end

Spira::Resource::ClassMethods.class_eval do
  include Devise::Models
  include Devise::Orm::Spira::Hook
end


#Данный файл отвечает за глобальные функции моделей, такие как поиск SPARQL и реализация некоторых недостающих стандартных функций ActiveModel
require 'sparql/client'


module SPARQL
  class Client
    class Query
#функция преобразования URI в сущность класса и функция-помощник для неявного определения класса внутри запроса-инстанциализатора
      def instance_class= klass
        @klass=klass
      end
      def instances
        self.result.map do |item|
          @klass[item[:s]]
        end
      end

#чейнинг-поиск. В том смысле что условия можно комбинировать, складывать в длинные цепочки как scope
      def _where(*args)
        options = args.extract_options!
        #все с учетом чейнинга
        sel=self #.clone если нужно можно будет приписать, чтобы изначальная сущность запроса не изменялась.
        sel=sel.select(:s).where([:s,RDF::type,@klass.type]) if sel.patterns.empty?
        #добавляем все ограничения
        options.each do |key,value|
          sel=sel.where([:s,@klass.properties[key][:predicate],value])
        end
        sel
      end

#преобразование к массиву - псевдоним для инстанциализации
      alias to_a instances
    end
  end
end



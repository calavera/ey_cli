module EYCli
  module SmartyParser
    def parse(body)
      case body
      when Hash
        new smarty(body)
      when Array
        body.map { |item| item.is_a?(Hash) ? parse(item) : item }
      else
        body
      end
    end

    def smarty(hash)
      hash.each do |key, value|
        case key
        when /accounts?/
          hash[key] = fill_model(value, EYCli::Model::Account)
        when /apps?/
          hash[key] = fill_model(value, EYCli::Model::App)
        when /environments?/
          hash[key] = fill_model(value, EYCli::Model::Environment)
        else
          hash[key] = fill_model(value)
        end
      end
    end

    def fill_model(value, klass = Hashie::Mash)
      if value.is_a? Hash
        klass.new smarty(value)
      elsif value.is_a? Array
        value.map {|v| klass.new smarty(v)}
      else
        value
      end
    end
  end
end

module EYCli
  module SmartyParser
    def parse(body, klass = self)
      case body
      when Hash
        klass.new smarty(body)
      when Array
        body.map { |item| parse(item) }
      else
        body
      end
    end

    def smarty(hash)
      hash.each do |key, value|
        case key
        when /accounts?/
          hash[key] = parse(value, EYCli::Model::Account)
        when /apps?/
          hash[key] = parse(value, EYCli::Model::App)
        when /environments?/
          hash[key] = parse(value, EYCli::Model::Environment)
        else
          hash[key] = parse(value, Hashie::Mash)
        end
      end
    end
  end
end

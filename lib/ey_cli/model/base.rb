module EYCli
  module Model
    class Base < Hashie::Mash
      extend EYCli::SmartyParser

      def self.all
        resp = EYCli.api.get(base_path)
        parse resp.body[base_path]
      end

      def self.find(*args)
        resp = EYCli.api.get(resolve_child_path(args))
        parse resp.body[class_name]
      end

      def self.find_by_name(name)
        # FIXME: EY api doesn't have filters. Let's do it by hand.
        all.select {|a| a.name == name }.first || raise(Faraday::Error::ResourceNotFound, all)
      end

      def self.base_path(path = "#{class_name}s") # HAX: pluralize!
        @base_path ||= path
      end

      def self.class_name
        self.name.split('::').last.downcase
      end

      def self.resolve_child_path(args)
        collection_path = base_path % args[0..-1]
        "#{collection_path}/#{args.last}"
      end

      # Overrides Hashie::Mash#convert_value to not convert already parsed Mashes again
      def convert_value(val, duping=false) #:nodoc:
        return val.dup if val.is_a?(Hashie::Mash)
        super(val, duping)
      end
    end
  end
end

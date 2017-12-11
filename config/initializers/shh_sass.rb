# monkey patch sass warnings during precompile
module Sass
  module Rails
    class SassImporter < Sass::Importers::Filesystem
      def marshal_dump
        p 'asdfasdfasdfasdf'
        # Return some kind of unique fingerprint to Sass
        @_marshal_id ||= object_id.to_s(16)
      end
      def marshal_load(*args)
        p 'sucksucksucksuckit'
        # Do nothing, we don't actually care if this is Marshalable
      end
    end
  end
end

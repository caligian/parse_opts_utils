# lib/main.rb

require 'fileutils'

# Output of all commands will be of the type Array unless mentioned otherwise
module POU
  class StringParam
    class << self
      # Just splits the string
      def split(str, sep)
        str.strip.split(Regexp.new(sep))
      end

      # First splits and then applies pred to each output
      def apply(str, sep, pred)
        split(str, sep).map { |s| pred.call(s) }
      end

      # Split and filter
      def filter(str, sep, pred)
        split(str, sep).select { |s| pred.call(s) }
      end

      # Split and grep
      def grep(str, sep, element, pred)
        split(str, sep).grep(element, pred)
      end

      # Splits. Tranformed value is value and str_array[INDEX] is key
      def to_h(str, sep, transform_pred)
        Hash[*split(str, sep).map { |s| [s, transform_pred.call(s)] }.flatten(1)]
      end
    end
  end

  # Same as above but for array params
  class ArrayParam
    class << self
      def apply(arr, pred)
        arr.map { |s| pred.call(s) }
      end

      def filter(arr, pred)
        arr.select { |s| pred.call(s) }
      end

      def grep(arr, element, pred)
        arr.grep(element, pred)
      end

      def to_h(arr, transform_pred)
        Hash[*arr.map { |s| [s, transform_pred.call(s)] }.flatten(1)]
      end
    end
  end

  # Path operations
  # Distinguishes String/Array params by itself and works on it.
  class Path
    class << self
      private

      # Get realpaths
      def _get_realpath_a(arr)
        ArrayParam.apply(arr, File.method('realpath'))
      end

      def _get_realpath_s(s, sep)
        StringParam.apply(s, sep, File.method('realpath'))
      end

      def _get_realpath_h(arr)
        ArrayParam.to_h(arr, File.method('realpath'))
      end

      # Get file contents
      def _get_content_from_file(loc)
        File.open(loc) { |fh| fh.read() }
      end

      def _get_content_a(arr)
        ArrayParam.apply(arr, self.method('_get_content_from_file'))
      end

      def _get_content_s(s, sep)
        StringParam.apply(s, sep, self.method('_get_content_from_file'))
      end

      def _get_content_h(arr)
        ArrayParam.to_h(arr, self.method('_get_content_from_file'))
      end

      public

      # Omnimethod. Pass the required params if type demands.
      #+ For eg. string param will need a sep function param
      def get_realpath(param, sep: /\s+/, hash: false)
        if hash
          param = param.is_a?(String) ? param.split(sep) : param
          _get_realpath_h(param)
        elsif param.is_a?(String)
          _get_realpath_s(param, sep)
        elsif param.is_a?(Array)
          _get_realpath_a(param)
        end
      end

      def get_content(param, sep: /\s+/, hash: false)
        if hash
          param = param.is_a?(String) ? param.split(sep) : param
          _get_content_h(param)
        elsif param.is_a?(String)
          _get_content_s(param, sep)
        elsif param.is_a?(Array)
          _get_content_a(param)
        end
      end
    end
  end
end

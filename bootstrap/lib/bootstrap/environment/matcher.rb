# frozen_string_literal: true

module Bootstrap
  class Environment
    class Matcher
      attr_reader :platforms

      def initialize(group)
        @platforms = expand(group)
      end

      def match?(environment)
        platforms.include?(environment.platform)
      end

      def ==(other)
        platforms == other.platforms
      end

      private

      def expand(group)
        case group
        when :all
          PLATFORM.keys.dup
        when :unix
          %i(macos linux)
        else
          PLATFORM.keys.include?(group) ? [group] : raise(NotImplementedError)
        end
      end
    end
  end
end

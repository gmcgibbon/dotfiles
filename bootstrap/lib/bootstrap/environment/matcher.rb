# frozen_string_literal: true

module Bootstrap
  class Environment
    class Matcher
      attr_reader :platforms, :constraints

      def initialize(*groups, **constraints)
        @platforms = groups.flat_map { |group| expand(group) }
        @constraints = constraints
      end

      def match?(environment)
        platforms.include?(environment.platform) &&
          (constraints.empty? || constraints == environment.constraints)
      end

      def ==(other)
        platforms == other.platforms &&
          constraints == other.constraints
      end

      def +(other)
        Matcher.new(
          *(other.platforms.empty? ? platforms : other.platforms),
          **constraints.merge(other.constraints)
        )
      end

      private

      def expand(group)
        case group
        when :all
          PLATFORM.keys.dup
        when :none
          []
        when :unix
          %i(macos linux)
        else
          PLATFORM.keys.include?(group) ? [group] : raise(NotImplementedError)
        end
      end
    end
  end
end

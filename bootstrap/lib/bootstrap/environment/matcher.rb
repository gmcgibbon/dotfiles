# frozen_string_literal: true

module Bootstrap
  class Environment
    class Matcher
      attr_reader :platforms, :constraints

      def initialize(*groups, **constraints)
        @platforms = groups.flat_map { |group| expand(group) }.uniq
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
          **constraints.merge(other.constraints),
        )
      end

      private

      def expand(group)
        case group
        when :all
          Environment.platforms.dup
        when :none
          []
        when :unix
          %i(macos fedora ubuntu)
        when :linux
          %i(fedora ubuntu)
        else
          default_platform(group)
        end
      end

      def default_platform(group)
        if Environment.platforms.include?(group)
          [group]
        else
          raise(NotImplementedError, "Group #{group} not found")
        end
      end
    end
  end
end

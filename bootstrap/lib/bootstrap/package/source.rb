# frozen_string_literal: true

module Bootstrap
  class Package
    class Source
      attr_reader :name, :location, :script

      def initialize(package, name: nil, script: nil, **package_manager_options)
        @package = package
        @location = parse_location(**package_manager_options)
        @package_manager = parse_package_manager(**package_manager_options)
        @script = script
        @name = name || format_package_name(package.name)
      end

      def package_manager
        @package.environment.package_managers[@package_manager]
      end

      def first_party?
        !location && !script
      end

      def third_party?
        location && !script
      end

      def script?
        !location && script
      end

      private

      def format_package_name(package_name)
        case package_manager
        when Winget.singleton_class
          package_name.sub(/^[a-z\d]*/, &:capitalize)
        else
          package_name
        end
      end

      def parse_package_manager(snap: nil, brew: nil, apt: nil)
        (snap && "snap") || (apt && "apt") || (brew && "brew")
      end

      def parse_location(snap: nil, brew: nil, apt: nil)
        location = snap || apt || brew # NOTE: winget currently does not support third party
        location.is_a?(String) && location
      end
    end
  end
end

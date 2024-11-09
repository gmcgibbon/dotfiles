# frozen_string_literal: true

module Bootstrap
  class Package
    class Source
      attr_reader :name, :location, :script

      def initialize(package, name: nil, script: nil, **package_manager_options)
        @package = package
        @package_manager = parse_package_manager(**package_manager_options)
        @location = parse_location(**package_manager_options)
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

      def environment
        @package.environment.platform
      end

      def format_package_name(package_name)
        case package_manager
        when Winget.singleton_class
          package_name.sub(/^[a-z\d]*/, &:capitalize)
        else
          package_name
        end
      end

      def parse_package_manager(**options)
        case environment
        when :ubuntu
          parse_ubuntu_package_manager(**options)
        when :fedora
          parse_fedora_package_manager(**options)
        else
          options.keys.first
        end
      end

      def parse_ubuntu_package_manager(apt: nil, snap: nil)
        (snap && "snap") || (apt && "apt")
      end

      def parse_fedora_package_manager(dnf: nil, flatpak: nil)
        (flatpak && "flatpak") || (dnf && "dnf")
      end

      def parse_location(**options)
        location = options[parse_package_manager(**options)&.to_sym]
        !location.is_a?(TrueClass) && location
      end
    end
  end
end

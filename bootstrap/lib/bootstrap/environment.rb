# frozen_string_literal: true

module Bootstrap
  class Environment
    PLATFORM = {
      windows: /mingw/,
      macos: /darwin/,
      linux: /linux/,
    }.freeze
    DISTRO = {
      fedora: /Red Hat/,
      ubuntu: /Ubuntu/,
    }.freeze

    private_constant(:PLATFORM, :DISTRO)

    class << self
      public :system

      def version
        `cat /proc/version`
      end

      def platforms
        @platforms ||= PLATFORM.except(:linux).merge(DISTRO).keys
      end
    end

    def platform
      @platform ||= PLATFORM.find do |symbol, regex|
        break distro(symbol) if RUBY_PLATFORM.downcase.match?(regex)
      end || raise(NotImplementedError, "Couldn't determine platform")
    end

    def constraints
      @constraints ||= { gui: gui? }
    end

    def package_managers
      case platform
      when :macos
        package_manager_hash(Brew, default: Brew)
      when :ubuntu
        package_manager_hash(Apt, Snap, default: Apt)
      when :fedora
        package_manager_hash(Dnf, Flatpak, default: Dnf)
      when :windows
        package_manager_hash(Winget, default: Winget)
      end
    end

    def install(package_name)
      Package.new(package_name, environment: self).install
    end

    def run(script)
      Environment.system(script)
    end

    private

    def distro(platform)
      if platform == :linux
        version = self.class.version
        DISTRO.find do |symbol, regex|
          break symbol if version.match?(regex)
        end || raise(NotImplementedError, "Couldn't determine Linux platform")
      else
        platform
      end
    end

    def gui?
      case platform
      when :macos, :ubuntu, :fedora
        !(ENV["DISPLAY"] || ENV.fetch("TERM_PROGRAM", nil)).nil?
      when :windows
        true
      end
    end

    def package_manager_hash(*package_managers, default:)
      hash = package_managers.to_h do |package_manager|
        [package_manager.command_name, package_manager]
      end
      hash.default = default
      hash
    end
  end

  private_constant(:Environment)
end

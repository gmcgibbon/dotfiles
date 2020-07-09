# frozen_string_literal: true

module Bootstrap
  class Environment
    PLATFORM = {
      windows: /mingw/,
      macos: /darwin/,
      linux: /linux/,
    }.freeze

    private_constant(:PLATFORM)

    class << self
      def [](group)
        Matcher.new(group)
      end

      public :system
    end

    def platform
      @platform ||= begin
        PLATFORM.find do |symbol, regex|
          break symbol if RUBY_PLATFORM.downcase.match?(regex)
        end || raise(NotImplementedError)
      end
    end

    def package_managers
      case platform
      when :macos
        package_manager_hash(Brew, default: Brew)
      when :linux
        package_manager_hash(Apt, Snap, default: Apt)
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

    def package_manager_hash(*package_managers, default:)
      hash = package_managers.map do |package_manager|
        [package_manager.command_name, package_manager]
      end.to_h
      hash.default = default
      hash
    end
  end

  private_constant(:Environment)
end

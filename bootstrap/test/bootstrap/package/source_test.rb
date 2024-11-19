# frozen_string_literal: true

require("test_helper")

module Bootstrap
  class Package
    class SourceTest < TestCase
      test "#location" do
        with_ruby_platform("darwin") do
          assert_equal "some_location", Source.new(package, brew: "some_location").location
        end
        with_ruby_platform("linux") do
          with_linux_version("Ubuntu") do
            assert_equal "some_location", Source.new(package, apt: "some_location").location
          end
        end
        assert_not Source.new(package).location
      end

      test "#script" do
        assert_equal "some_script", Source.new(package, script: "some_script").script
        assert_nil Source.new(package).script
      end

      test "#name" do
        assert_equal "pkg", Source.new(package).name
        assert_equal "alias_pkg", Source.new(package, name: "alias_pkg").name
      end

      test "#package_manager" do
        with_ruby_platform("linux") do
          with_linux_version("Ubuntu") do
            assert_equal Snap, Source.new(package, snap: true).package_manager
            assert_equal Apt, Source.new(package, apt: true).package_manager
            assert_equal Apt, Source.new(package).package_manager
          end
        end

        with_ruby_platform("linux") do
          with_linux_version("Red Hat") do
            assert_equal Flatpak, Source.new(package, flatpak: true).package_manager
            assert_equal Dnf, Source.new(package, dnf: true).package_manager
            assert_equal Dnf, Source.new(package).package_manager
          end
        end

        with_ruby_platform("darwin") do
          assert_equal Brew, Source.new(package, brew: true).package_manager
          assert_equal Brew, Source.new(package).package_manager
        end

        with_ruby_platform("mingw") do
          assert_equal Winget, Source.new(package).package_manager
        end
      end

      test "#first_party?" do
        with_ruby_platform("darwin") do
          assert_predicate Source.new(package), :first_party?
          assert_not_predicate Source.new(package, brew: "some_location"), :first_party?
          assert_not_predicate Source.new(package, script: "some_script"), :first_party?
        end
      end

      test "#third_party?" do
        with_ruby_platform("darwin") do
          assert_not_predicate Source.new(package), :third_party?
          assert_predicate Source.new(package, brew: "some_location"), :third_party?
          assert_not_predicate Source.new(package, script: "some_script"), :third_party?
        end
      end

      test "#script?" do
        with_ruby_platform("darwin") do
          assert_not_predicate Source.new(package), :script?
          assert_not_predicate Source.new(package, brew: "some_location"), :script?
          assert_predicate Source.new(package, script: "some_script"), :script?
        end
      end

      private

      def package
        Package.new("pkg", environment: Environment.new)
      end
    end
  end
end

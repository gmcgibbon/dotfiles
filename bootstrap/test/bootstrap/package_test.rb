# frozen_string_literal: true

require("test_helper")

module Bootstrap
  class PackageTest < TestCase
    test ".sources" do
      sources = YAML.load_file(File.expand_path("../../lib/bootstrap/package/sources.yml", __dir__))
      assert_equal sources, Package.sources
    end

    test "#name" do
      assert_equal "pkg", package.name
    end

    test "#environment" do
      assert_instance_of Environment, package.environment
    end

    private

    def package
      Package.new("pkg", environment: Environment.new)
    end
  end

  class PackageInstallTest < PackageTest
    private

    def third_party_package
      Package.new("third_party_pkg", environment: Environment.new)
    end

    def script_package
      Package.new("script_pkg", environment: Environment.new)
    end

    def alias_package
      Package.new("alias_pkg", environment: Environment.new)
    end

    def test_dependencies
      YAML.load_file(file_fixture("sources.yml"))
    end
  end

  class PackageMacInstallTest < PackageInstallTest
    test "#install on mac" do
      with_ruby_platform("Darwin") do
        assert_called_with(Brew, :install, %w(pkg)) do
          package.install
        end
      end
    end

    test "#install on mac with third party source" do
      with_ruby_platform("Darwin") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Brew, :source, %w(dummy/tap)) do
            assert_called_with(Brew, :install, %w(third_party_pkg)) do
              third_party_package.install
            end
          end
        end
      end
    end

    test "#install on mac with script source" do
      with_ruby_platform("Darwin") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Environment, :system, ["git clone for_mac"]) do
            assert_not_called(Brew, :install) do
              script_package.install
            end
          end
        end
      end
    end

    test "#install on mac with alias name" do
      with_ruby_platform("Darwin") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Brew, :install, %w(aliased_mac)) do
            alias_package.install
          end
        end
      end
    end
  end

  class PackageLinuxInstallTest < PackageInstallTest
    test "#install on linux" do
      with_ruby_platform("Linux") do
        assert_called_with(Apt, :install, %w(pkg)) do
          package.install
        end
      end
    end

    test "#install on linux with third party source" do
      with_ruby_platform("Linux") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Apt, :source, %w(ppa:dummy)) do
            assert_called_with(Apt, :install, %w(third_party_pkg)) do
              third_party_package.install
            end
          end
        end
      end
    end

    test "#install on linux with script source" do
      with_ruby_platform("Linux") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Environment, :system, ["git clone for_linux"]) do
            assert_not_called(Apt, :install) do
              script_package.install
            end
          end
        end
      end
    end

    test "#install on linux with alias name" do
      with_ruby_platform("Linux") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Apt, :install, %w(aliased_linux)) do
            alias_package.install
          end
        end
      end
    end

    test "#install on linux with snap" do
      with_ruby_platform("Linux") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Snap, :install, %w(snap_pkg)) do
            snap_package.install
          end
        end
      end
    end

    private

    def snap_package
      Package.new("snap_pkg", environment: Environment.new)
    end
  end

  class PackageWindowsInstallTest < PackageInstallTest
    test "#install on windows" do
      with_ruby_platform("Mingw") do
        assert_called_with(Winget, :install, %w(pkg)) do
          package.install
        end
      end
    end

    test "#install on windows with alias name" do
      with_ruby_platform("Mingw") do
        assert_called(Package, :sources, returns: test_dependencies) do
          assert_called_with(Winget, :install, %w(aliased_win)) do
            alias_package.install
          end
        end
      end
    end
  end
end

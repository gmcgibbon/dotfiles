# frozen_string_literal: true

require("test_helper")

module Bootstrap
  class PackageTest < TestCase
    test "#initialize" do
      ["Calitalized", "under_scored", "Spaced name"].each do |malformed_name|
        error = assert_raises(ArgumentError) do
          Package.new(malformed_name, environment: Environment.new)
        end

        assert_equal <<~MSG, error.message
          Package name "#{malformed_name}" is invalid! Please use lowercase hyphenated names only.
        MSG
      end
    end

    test ".sources" do
      sources = YAML.safe_load_file(
        File.expand_path("../../lib/bootstrap/package/sources.yml", __dir__),
        aliases: true,
      )

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
      Package.new("third-party-pkg", environment: Environment.new)
    end

    def other_third_party_package
      Package.new("other-third-party-pkg", environment: Environment.new)
    end

    def script_package
      Package.new("script-pkg", environment: Environment.new)
    end

    def alias_package
      Package.new("alias-pkg", environment: Environment.new)
    end

    def test_dependencies
      YAML.safe_load_file(file_fixture("sources.yml"))
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
            assert_called_with(Brew, :install, %w(third-party-pkg)) do
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

  class PackageUbuntuInstallTest < PackageInstallTest
    test "#install on ubuntu" do
      with_ruby_platform("Linux") do
        with_linux_version("Ubuntu") do
          assert_called_with(Apt, :install, %w(pkg)) do
            package.install
          end
        end
      end
    end

    test "#install on ubuntu with third party source" do
      with_ruby_platform("Linux") do
        with_linux_version("Ubuntu") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Apt, :source, %w(ppa:dummy)) do
              assert_called_with(Apt, :install, %w(third-party-pkg)) do
                third_party_package.install
              end
            end
          end
        end
      end
    end

    test "#install on ubuntu with script source" do
      with_ruby_platform("Linux") do
        with_linux_version("Ubuntu") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Environment, :system, ["git clone for_ubuntu"]) do
              assert_not_called(Apt, :install) do
                script_package.install
              end
            end
          end
        end
      end
    end

    test "#install on ubuntu with alias name" do
      with_ruby_platform("Linux") do
        with_linux_version("Ubuntu") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Apt, :install, %w(aliased_ubuntu)) do
              alias_package.install
            end
          end
        end
      end
    end

    test "#install on ubuntu with snap" do
      with_ruby_platform("Linux") do
        with_linux_version("Ubuntu") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Snap, :install, %w(snap-pkg)) do
              snap_package.install
            end
          end
        end
      end
    end

    private

    def snap_package
      Package.new("snap-pkg", environment: Environment.new)
    end
  end

  class PackageFedoraInstallTest < PackageInstallTest
    test "#install on fedora" do
      with_ruby_platform("Linux") do
        with_linux_version("Red Hat") do
          assert_called_with(Dnf, :install, %w(pkg)) do
            package.install
          end
        end
      end
    end

    test "#install on fedora with third party repo source" do
      repo_source = {
        "name" => "test", "baseurl" => "testuri", "gpgkey" => "testgpgkey",
      }

      with_ruby_platform("Linux") do
        with_linux_version("Red Hat") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Dnf, :source, [repo_source]) do
              assert_called_with(Dnf, :install, %w(third-party-pkg)) do
                third_party_package.install
              end
            end
          end
        end
      end
    end

    test "#install on fedora with third party copr source" do
      copr_source = {
        "copr" => "some/repo",
      }

      with_ruby_platform("Linux") do
        with_linux_version("Red Hat") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Dnf, :source, [copr_source]) do
              assert_called_with(Dnf, :install, %w(other-third-party-pkg)) do
                other_third_party_package.install
              end
            end
          end
        end
      end
    end

    test "#install on fedora with script source" do
      with_ruby_platform("Linux") do
        with_linux_version("Red Hat") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Environment, :system, ["git clone for_fedora"]) do
              assert_not_called(Dnf, :install) do
                script_package.install
              end
            end
          end
        end
      end
    end

    test "#install on fedora with alias name" do
      with_ruby_platform("Linux") do
        with_linux_version("Red Hat") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Dnf, :install, %w(aliased_fedora)) do
              alias_package.install
            end
          end
        end
      end
    end

    test "#install on fedora with flatpak" do
      with_ruby_platform("Linux") do
        with_linux_version("Red Hat") do
          assert_called(Package, :sources, returns: test_dependencies) do
            assert_called_with(Flatpak, :install, %w(flatpak-pkg)) do
              flatpak_package.install
            end
          end
        end
      end
    end

    private

    def flatpak_package
      Package.new("flatpak-pkg", environment: Environment.new)
    end
  end

  class PackageWindowsInstallTest < PackageInstallTest
    test "#install on windows" do
      with_ruby_platform("Mingw") do
        assert_called_with(Winget, :install, %w(Pkg)) do
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

# frozen_string_literal: true

require("test_helper")

module Bootstrap
  class PackageManagerTest < TestCase
    test ".command_name" do
      assert_equal "package_manager", PackageManager.command_name
    end

    test ".install" do
      assert_called_with(PackageManager, :system, %w(package_manager install some_package)) do
        PackageManager.install("some_package")
      end
    end

    test ".source" do
      assert_raises(NotImplementedError) do
        PackageManager.source("some/location")
      end
    end
  end

  class BrewTest < TestCase
    test ".command_name" do
      assert_equal "brew", Brew.command_name
    end

    test ".install" do
      with_no_casks do
        assert_called_with(Brew, :system, %w(brew install some-package)) do
          Brew.install("some-package")
        end
      end
    end

    test ".install cask package" do
      with_casks(%w(some-package)) do
        assert_called_with(Brew, :system, %w(brew install --cask some-package)) do
          Brew.install("some-package")
        end
      end
    end

    test ".source" do
      assert_called_with(Brew, :system, %w(brew tap some/location)) do
        Brew.source("some/location")
      end
    end

    private

    def with_casks(cask_packages, &block)
      Brew.stub(:cask_packages, cask_packages, &block)
    end

    def with_no_casks(&block)
      with_casks([], &block)
    end
  end

  class WingetTest < TestCase
    test ".command_name" do
      assert_equal "winget", Winget.command_name
    end

    test ".install" do
      assert_called_with(Winget, :system, %w(winget install -e SomePackage)) do
        Winget.install("SomePackage")
      end
    end
  end

  class AptTest < TestCase
    test ".command_name" do
      assert_equal "apt", Apt.command_name
    end

    test ".install" do
      assert_called_with(Apt, :system, %w(apt install -y some-package)) do
        Apt.install("some-package")
      end
    end

    test ".source" do
      assert_called_with(Apt, :system, [%w(add-apt-repository -y ppa:location), %w(apt update)]) do
        Apt.source("ppa:location")
      end
    end

    class SnapTest < TestCase
      test ".command_name" do
        assert_equal "snap", Snap.command_name
      end

      test ".install" do
        assert_called_with(Snap, :system, %w(snap install --classic some-package)) do
          Snap.install("some-package")
        end
      end
    end
  end
end

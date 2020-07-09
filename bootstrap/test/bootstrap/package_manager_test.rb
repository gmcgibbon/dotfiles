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
        assert_called_with(Brew, :system, %w(brew install some_package)) do
          Brew.install("some_package")
        end
      end
    end

    test ".install cask package" do
      with_casks(%w(some_package)) do
        assert_called_with(Brew, :system, %w(brew cask install some_package)) do
          Brew.install("some_package")
        end
      end
    end

    test ".source" do
      assert_called_with(Brew, :system, %w(brew tap some/location)) do
        Brew.source("some/location")
      end
    end

    private

    def with_casks(cask_packages)
      Brew.stub(:cask_packages, cask_packages) do
        yield
      end
    end

    def with_no_casks
      with_casks([]) { yield }
    end
  end

  class WingetTest < TestCase
    test ".command_name" do
      assert_equal "winget", Winget.command_name
    end

    test ".install" do
      assert_called_with(Winget, :system, %w(winget install -e Some_package)) do
        Winget.install("some_package")
      end
    end
  end

  class AptTest < TestCase
    test ".command_name" do
      assert_equal "apt", Apt.command_name
    end

    test ".install" do
      assert_called_with(Apt, :system, %w(apt install -y some_package)) do
        Apt.install("some_package")
      end
    end

    test ".source" do
      assert_called_with(Apt, :system, [%w(add-apt-repository ppa:location), %w(apt update)]) do
        Apt.source("ppa:location")
      end
    end

    class SnapTest < TestCase
      test ".command_name" do
        assert_equal "snap", Snap.command_name
      end

      test ".install" do
        assert_called_with(Snap, :system, %w(snap install --classic some_package)) do
          Snap.install("some_package")
        end
      end
    end
  end
end

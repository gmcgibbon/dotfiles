# frozen_string_literal: true

require_relative("test_helper")

module Bootstrap
  class UbuntuTest < TestCase
    test "installs antigen" do
      assert_installed_at("~/.zsh/antigen")
    end

    test "installs vundle" do
      assert_installed_at("~/.vim/bundle/Vundle.vim")
    end

    test "installs rbenv" do
      assert_installed_at("~/.rbenv")
    end

    test "installs nvm" do
      assert_installed_at("~/.nvm")
    end

    test "installs zsh" do
      assert_apt_installed("zsh")
    end

    test "installs rcm" do
      assert_apt_installed("rcm")
    end

    test "installs vim" do
      assert_apt_installed("vim")
    end

    test "installs fastfetch" do
      assert_apt_installed("fastfetch")
    end

    test "installs heroku" do
      assert_apt_installed("heroku")
    end

    test "installs ripgrep" do
      assert_apt_installed("ripgrep")
    end

    test "installs btop" do
      assert_snap_installed("btop")
    end

    test "installs ollama" do
      assert_installed_at("/usr/local/bin/ollama")
    end

    if gui?
      test "installs firefox" do
        assert_apt_installed("firefox")
      end

      test "installs vlc" do
        assert_snap_installed("vlc")
      end

      test "installs steam" do
        assert_apt_installed("steam")
      end

      test "installs visual studio code" do
        assert_snap_installed("code")
      end

      test "installs skype" do
        assert_snap_installed("skype")
      end

      test "installs zoom" do
        assert_snap_installed("zoom-client")
      end

      test "installs spotify" do
        assert_snap_installed("spotify")
      end

      test "installs slack" do
        assert_snap_installed("slack")
      end

      test "installs gimp" do
        assert_apt_installed("gimp")
      end

      test "installs qemu" do
        assert_apt_installed("qemu")
      end

      test "installs localsend" do
        assert_snap_installed("localsend")
      end

      test "installs pinta" do
        assert_apt_installed("pinta")
      end
    else
      test "does not install flux" do
        assert_apt_not_installed("fluxgui")
      end

      test "does not install vlc" do
        assert_snap_not_installed("vlc")
      end

      test "does not install steam" do
        assert_apt_not_installed("steam")
      end

      test "does not install visual studio code" do
        assert_snap_not_installed("code")
      end

      test "does not install skype" do
        assert_snap_not_installed("skype")
      end

      test "does not install zoom" do
        assert_snap_not_installed("zoom-client")
      end

      test "does not install spotify" do
        assert_snap_not_installed("spotify")
      end

      test "does not install slack" do
        assert_snap_not_installed("slack")
      end

      test "does not install gimp" do
        assert_apt_not_installed("gimp")
      end

      test "does not install qemu" do
        assert_apt_not_installed("qemu")
      end

      test "does not install localsend" do
        assert_snap_not_installed("localsend")
      end

      test "does not install pinta" do
        assert_apt_not_installed("pinta")
      end
    end

    private

    def assert_apt_installed(package_name)
      assert_predicate(Open3.capture3("apt list --installed | grep #{package_name}").last, :success?)
    end

    def assert_apt_not_installed(package_name)
      assert_not_predicate(Open3.capture3("apt list --installed | grep #{package_name}").last, :success?)
    end

    def assert_snap_installed(package_name)
      assert_predicate(Open3.capture3("snap list #{package_name}").last, :success?)
    end

    def assert_snap_not_installed(package_name)
      assert_not_predicate(Open3.capture3("snap list #{package_name}").last, :success?)
    end

    def assert_installed_at(path)
      assert_predicate(Pathname(path).expand_path, :exist?)
    end
  end
end

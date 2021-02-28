# frozen_string_literal: true

require_relative("test_helper")

module Bootstrap
  class LinuxTest < TestCase
    test "installs antigen" do
      assert_installed_at("~/.zsh/antigen")
    end

    test "installs vundle" do
      assert_installed_at("~/.vim/bundle/Vundle.vim")
    end

    test "installs rbenv" do
      assert_installed_at("~/.rbenv")
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

    test "installs firefox" do
      assert_apt_installed("firefox")
    end

    test "installs flux" do
      assert_apt_installed("fluxgui")
    end

    test "installs vlc" do
      assert_apt_installed("vlc")
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

    test "installs spotify" do
      assert_snap_installed("spotify")
    end

    private

    def assert_apt_installed(package_name)
      assert_predicate(Open3.capture3("apt list #{package_name}").last, :success?)
    end

    def assert_snap_installed(package_name)
      assert_predicate(Open3.capture3("snap list #{package_name}").last, :success?)
    end

    def assert_installed_at(path)
      assert_predicate(Pathname(path).expand_path, :exist?)
    end
  end
end

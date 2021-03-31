# frozen_string_literal: true

require_relative("test_helper")

module Bootstrap
  class MacosTest < TestCase
    test "installs antigen" do
      assert_installed_at("~/.zsh/antigen")
    end

    test "installs vundle" do
      assert_installed_at("~/.vim/bundle/Vundle.vim")
    end

    test "installs rbenv" do
      assert_brew_installed("rbenv")
    end

    test "installs nvm" do
      assert_brew_installed("nvm")
    end

    test "installs zsh" do
      assert_brew_installed("zsh")
    end

    test "installs rcm" do
      assert_brew_installed("rcm")
    end

    test "installs vim" do
      assert_brew_installed("vim")
    end

    test "installs iterm2" do
      assert_brew_cask_installed("iterm2")
    end

    test "installs firefox" do
      assert_brew_cask_installed("firefox")
    end

    test "installs flux" do
      assert_brew_cask_installed("flux")
    end

    test "installs vlc" do
      assert_brew_cask_installed("vlc")
    end

    test "installs steam" do
      assert_brew_cask_installed("steam")
    end

    test "installs visual studio code" do
      assert_brew_cask_installed("visual-studio-code")
    end

    test "installs skype" do
      assert_brew_cask_installed("skype")
    end

    test "installs spotify" do
      assert_brew_cask_installed("spotify")
    end

    private

    def assert_brew_installed(package_name)
      assert_predicate(Open3.capture3("brew list #{package_name}").last, :success?)
    end

    def assert_brew_cask_installed(package_name)
      assert_predicate(Open3.capture3("brew list --cask #{package_name}").last, :success?)
    end

    def assert_installed_at(path)
      assert_predicate(Pathname(path).expand_path, :exist?)
    end
  end
end

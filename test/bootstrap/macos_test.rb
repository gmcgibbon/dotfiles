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
      assert_installed_at("~/.nvm")
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

    test "installs fastfetch" do
      assert_brew_installed("fastfetch")
    end

    test "installs heroku" do
      assert_brew_installed("heroku")
    end

    test "installs ripgrep" do
      assert_brew_installed("ripgrep")
    end

    test "installs btop" do
      assert_brew_installed("btop")
    end

    test "installs ollama" do
      assert_brew_installed("ollama")
    end

    test "installs fzf" do
      assert_brew_installed("fzf")
    end

    test "installs fd" do
      assert_brew_installed("fd")
    end

    test "installs zellij" do
      assert_brew_installed("zellij")
    end

    if gui?
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

      test "installs zoom" do
        assert_brew_cask_installed("zoom")
      end

      test "installs spotify" do
        assert_brew_cask_installed("spotify")
      end

      test "installs slack" do
        assert_brew_cask_installed("slack")
      end

      test "installs gimp" do
        assert_brew_cask_installed("gimp")
      end

      test "installs qemu" do
        assert_brew_installed("qemu")
      end

      test "installs localsend" do
        assert_brew_cask_installed("localsend")
      end

      test "installs pinta" do
        assert_brew_cask_installed("pinta")
      end

      test "installs xournalpp" do
        assert_brew_cask_installed("xournal++")
      end

      test "installs alacritty" do
        assert_brew_cask_installed("alacritty")
      end

      test "installs discord" do
        assert_brew_cask_installed("discord")
      end
    else
      test "does not install flux" do
        assert_brew_cask_not_installed("flux")
      end

      test "does not install vlc" do
        assert_brew_cask_not_installed("vlc")
      end

      test "does not install steam" do
        assert_brew_cask_not_installed("steam")
      end

      test "does not install visual studio code" do
        assert_brew_cask_not_installed("visual-studio-code")
      end

      test "does not install zoom" do
        assert_brew_cask_not_installed("zoom")
      end

      test "does not install spotify" do
        assert_brew_cask_not_installed("spotify")
      end

      test "does not install slack" do
        assert_brew_cask_not_installed("slack")
      end

      test "does not install gimp" do
        assert_brew_cask_not_installed("gimp")
      end

      test "does not install qemu" do
        assert_brew_not_installed("qemu")
      end

      test "does not install localsend" do
        assert_brew_cask_not_installed("localsend")
      end

      test "does not install pinta" do
        assert_brew_cask_not_installed("pinta")
      end

      test "does not install xournalpp" do
        assert_brew_cask_not_installed("xournal++")
      end

      test "does not install alacritty" do
        assert_brew_cask_not_installed("alacritty")
      end

      test "does not install discord" do
        assert_brew_cask_not_installed("discord")
      end
    end

    private

    def assert_brew_installed(package_name)
      assert_predicate(Open3.capture3("brew list #{package_name}").last, :success?)
    end

    def assert_brew_not_installed(package_name)
      assert_not_predicate(Open3.capture3("brew list #{package_name}").last, :success?)
    end

    def assert_brew_cask_installed(package_name)
      assert_predicate(Open3.capture3("brew list --cask #{package_name}").last, :success?)
    end

    def assert_brew_cask_not_installed(package_name)
      assert_not_predicate(Open3.capture3("brew list --cask #{package_name}").last, :success?)
    end

    def assert_installed_at(path)
      assert_predicate(Pathname(path).expand_path, :exist?)
    end
  end
end

# frozen_string_literal: true

require_relative("test_helper")

module Bootstrap
  class WindowsTest < TestCase
    test "installs discord" do
      assert_winget_installed("Discord")
    end

    test "installs vim" do
      assert_winget_installed("vim.vim")
    end

    test "installs firefox" do
      assert_winget_installed("Firefox")
    end

    test "installs flux" do
      assert_winget_installed("flux.flux")
    end

    test "installs vlc" do
      assert_winget_installed("VideoLAN.VLC")
    end

    test "installs steam" do
      assert_winget_installed("Steam")
    end

    test "installs visual studio code" do
      assert_winget_installed("Microsoft.VisualStudioCode")
    end

    test "installs skype" do
      assert_winget_installed("Skype")
    end

    test "installs zoom" do
      assert_winget_installed("Zoom.Zoom")
    end unless ENV["CI"] # NOTE: Doesn't install on an elevated prompt.

    test "installs spotify" do
      assert_winget_installed("Spotify")
    end unless ENV["CI"] # NOTE: Doesn't install on an elevated prompt.

    test "installs slack" do
      assert_winget_installed("Slack")
    end

    test "installs gimp" do
      assert_winget_installed("GIMP.GIMP")
    end

    test "installs qemu" do
      assert_winget_installed("SoftwareFreedomConservancy.QEMU")
    end

    private

    def assert_winget_installed(package_name)
      assert_predicate(Open3.capture3("winget list #{package_name}").last, :success?)
    end
  end
end

# frozen_string_literal: true

require_relative("test_helper")

module Bootstrap
  class WindowsTest < TestCase
    test "installs discord" do
      assert_winget_installed("Discord")
    end

    test "installs vim" do
      assert_winget_installed("Vim")
    end

    test "installs firefox" do
      assert_winget_installed("Firefox")
    end

    test "installs flux" do
      assert_winget_installed("Flux")
    end

    test "installs vlc" do
      assert_winget_installed("Vlc")
    end

    test "installs steam" do
      assert_winget_installed("Steam")
    end

    test "installs visual studio code" do
      assert_winget_installed("VisualStudioCode")
    end

    test "installs skype" do
      assert_winget_installed("Skype")
    end

    test "installs spotify" do
      assert_winget_installed("Spotify")
    end

    test "installs slack" do
      assert_winget_installed("Slack")
    end

    private

    def assert_winget_installed(package_name)
      assert_predicate(Open3.capture3("winget show #{package_name}").last, :success?)
    end
  end
end

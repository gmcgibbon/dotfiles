# frozen_string_literal: true

require("test_helper")

module Bootstrap
  class Environment
    class MatcherTest < TestCase
      test "#initialize" do
        Matcher.new(:all)
      end

      test "#initialize invalid group" do
        assert_raises(NotImplementedError) do
          Matcher.new(:does_not_exist)
        end
      end

      test "#platforms" do
        assert_equal PLATFORM.keys, Matcher.new(:all).platforms
        assert_equal %i(macos linux), Matcher.new(:unix).platforms
        PLATFORM.each_key do |platform|
          assert_equal [platform], Matcher.new(platform).platforms
        end
      end

      test "#match?" do
        assert_operator Matcher.new(:all), :match?, macos_environment
        assert_operator Matcher.new(:all), :match?, linux_environment
        assert_operator Matcher.new(:all), :match?, windows_environment

        assert_operator Matcher.new(:unix), :match?, macos_environment
        assert_operator Matcher.new(:unix), :match?, linux_environment
        assert_not_operator Matcher.new(:unix), :match?, windows_environment

        assert_operator Matcher.new(:macos), :match?, macos_environment
        assert_not_operator Matcher.new(:macos), :match?, linux_environment
        assert_not_operator Matcher.new(:macos), :match?, windows_environment

        assert_not_operator Matcher.new(:linux), :match?, macos_environment
        assert_operator Matcher.new(:linux), :match?, linux_environment
        assert_not_operator Matcher.new(:linux), :match?, windows_environment

        assert_not_operator Matcher.new(:windows), :match?, macos_environment
        assert_not_operator Matcher.new(:windows), :match?, linux_environment
        assert_operator Matcher.new(:windows), :match?, windows_environment
      end

      test "#==" do
        PLATFORM.each_key do |platform|
          assert_equal Matcher.new(platform), Matcher.new(platform)
        end
        assert_equal Matcher.new(:all), Matcher.new(:all)
        assert_equal Matcher.new(:unix), Matcher.new(:unix)
        assert_not_equal Matcher.new(:all), Matcher.new(:unix)
      end

      private

      def macos_environment
        with_ruby_platform("Darwin") do
          Environment.new.tap(&:platform)
        end
      end

      def linux_environment
        with_ruby_platform("Linux") do
          Environment.new.tap(&:platform)
        end
      end

      def windows_environment
        with_ruby_platform("Mingw") do
          Environment.new.tap(&:platform)
        end
      end
    end
  end
end

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

      test "#constraints" do
        assert_equal({ gui: true }, Matcher.new(:all, gui: true).constraints)
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

        assert_operator Matcher.new(:linux, gui: true), :match?, linux_environment("DISPLAY" => "1")
        assert_not_operator Matcher.new(:linux, gui: true), :match?, linux_environment("DISPLAY" => nil)
      end

      test "#==" do
        PLATFORM.each_key do |platform|
          assert_equal Matcher.new(platform), Matcher.new(platform)
        end
        assert_equal Matcher.new(:all), Matcher.new(:all)
        assert_equal Matcher.new(:unix), Matcher.new(:unix)
        assert_not_equal Matcher.new(:all), Matcher.new(:unix)

        assert_equal Matcher.new(:none), Matcher.new(:none)
        assert_equal Matcher.new(:all, gui: true), Matcher.new(:all, gui: true)
        assert_not_equal Matcher.new(:none, gui: true), Matcher.new(:none)
      end

      test "#+" do
        assert_equal Matcher.new(:macos), Matcher.new(:all) + Matcher.new(:macos)
        assert_equal Matcher.new(:all, gui: true), Matcher.new(:all) + Matcher.new(:none, gui: true)
        assert_equal Matcher.new(:all, gui: true), Matcher.new(:none, gui: true) + Matcher.new(:all)
        assert_equal Matcher.new(:all), Matcher.new(:all) + Matcher.new(:none)
        assert_equal Matcher.new(:linux, gui: false), Matcher.new(:linux) + Matcher.new(:none, gui: false)
      end

      private

      def macos_environment(env = {})
        with_ruby_platform("Darwin") do
          with_env(**env) do
            Environment.new.tap(&:platform).tap(&:constraints)
          end
        end
      end

      def linux_environment(env = {})
        with_ruby_platform("Linux") do
          with_env(**env) do
            Environment.new.tap(&:platform).tap(&:constraints)
          end
        end
      end

      def windows_environment(env = {})
        with_ruby_platform("Mingw") do
          with_env(**env) do
            Environment.new.tap(&:platform).tap(&:constraints)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require("test_helper")

module Bootstrap
  class EnvironmentTest < TestCase
    setup do
      @environment = Environment.new
    end

    test ".system" do
      assert_respond_to Environment, :system
    end

    test "#platform on linux" do
      with_ruby_platform("Some.Linux") do
        assert_equal(:linux, @environment.platform)
      end

      assert_same(:linux, @environment.platform)
    end

    test "#platform on mac" do
      with_ruby_platform("Darwin") do
        assert_equal(:macos, @environment.platform)
      end

      assert_same(:macos, @environment.platform)
    end

    test "#platform on windows" do
      with_ruby_platform("Mingw") do
        assert_equal(:windows, @environment.platform)
      end

      assert_same(:windows, @environment.platform)
    end

    test "#platform on unsupported os" do
      with_ruby_platform("WTF.Broken") do
        assert_raises(NotImplementedError) do
          @environment.platform
        end
      end
    end

    test "#constraints gui with display" do
      with_ruby_platform("Some.Linux") do
        with_env("DISPLAY" => "1") do
          assert_equal({ gui: true }, @environment.constraints)
        end
      end
    end

    test "#constraints gui with terminal program" do
      with_ruby_platform("Some.Linux") do
        with_env("TERM_PROGRAM" => "1") do
          assert_equal({ gui: true }, @environment.constraints)
        end
      end
    end

    test "#constraints gui with no display" do
      with_ruby_platform("Some.Linux") do
        with_env("DISPLAY" => nil, "TERM_PROGRAM" => nil) do
          assert_equal({ gui: false }, @environment.constraints)
        end
      end
    end

    test "#constraints gui on windows" do
      with_ruby_platform("Mingw") do
        assert_equal({ gui: true }, @environment.constraints)
      end
    end

    test "#package_managers on linux" do
      with_ruby_platform("Some.Linux") do
        assert_equal({ "apt" => Apt, "snap" => Snap }, @environment.package_managers)
        assert_equal(Apt, @environment.package_managers.default)
      end
    end

    test "#package_manager on mac" do
      with_ruby_platform("Darwin") do
        assert_equal({ "brew" => Brew }, @environment.package_managers)
        assert_equal(Brew, @environment.package_managers.default)
      end
    end

    test "#package_manager on windows" do
      with_ruby_platform("Mingw") do
        assert_equal({ "winget" => Winget }, @environment.package_managers)
        assert_equal(Winget, @environment.package_managers.default)
      end
    end

    test "#install" do
      with_ruby_platform("Mingw") do
        assert_called_with(Winget, :system, %w(winget install -e Pkg)) do
          @environment.install("pkg")
        end
      end
    end

    test "#run" do
      assert_called_with(Environment, :system, ["some command sequence"]) do
        @environment.run("some command sequence")
      end
    end
  end
end

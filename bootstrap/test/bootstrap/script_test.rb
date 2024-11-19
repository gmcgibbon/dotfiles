# frozen_string_literal: true

require("test_helper")

module Bootstrap
  class ScriptTestCase < TestCase
    setup do
      @script = Script.new
    end
  end

  class ScriptTest < ScriptTestCase
    test "#install on ubuntu" do
      with_ruby_platform("linux") do
        with_linux_version("Ubuntu") do
          assert_called_with(Apt, :install, %w(pkg)) do
            @script.install("pkg")
          end
        end
      end
    end

    test "#install on fedora" do
      with_ruby_platform("linux") do
        with_linux_version("Red Hat") do
          assert_called_with(Dnf, :install, %w(pkg)) do
            @script.install("pkg")
          end
        end
      end
    end
  end

  class ScriptConstrintsTest < ScriptTestCase
    test "#gui with display" do
      with_ruby_platform("linux") do
        with_linux_version("Ubuntu") do
          with_env("DISPLAY" => "1") do
            assert_called(Apt, :install) do
              @script.gui { @script.install("pkg") }
            end
          end
        end
      end
    end

    test "#gui with terminal program" do
      with_ruby_platform("linux") do
        with_env("TERM_PROGRAM" => "1") do
          with_linux_version("Ubuntu") do
            assert_called(Apt, :install) do
              @script.gui { @script.install("pkg") }
            end
          end
        end
      end
    end

    test "#gui without display" do
      with_ruby_platform("linux") do
        with_env("DISPLAY" => nil, "TERM_PROGRAM" => nil) do
          with_linux_version("Ubuntu") do
            assert_not_called(Apt, :install) do
              @script.gui { @script.install("pkg") }
            end
          end
        end
      end
    end

    test "#gui on windows" do
      with_ruby_platform("mingw") do
        assert_called(Winget, :install) do
          @script.gui { @script.install("pkg") }
        end
      end
    end
  end

  class ScriptPlatformTest < ScriptTestCase
    test "#unix on macos" do
      with_ruby_platform("darwin") do
        assert_called_with(Brew, :install, %w(pkg)) do
          @script.unix { @script.install("pkg") }
        end
      end
    end

    test "#unix on ubuntu" do
      with_ruby_platform("linux") do
        with_linux_version("Ubuntu") do
          assert_called_with(Apt, :install, %w(pkg)) do
            @script.unix { @script.install("pkg") }
          end
        end
      end
    end

    test "#unix on fedora" do
      with_ruby_platform("linux") do
        with_linux_version("Red Hat") do
          assert_called_with(Dnf, :install, %w(pkg)) do
            @script.unix { @script.install("pkg") }
          end
        end
      end
    end

    test "#unix on windows" do
      with_ruby_platform("mingw") do
        assert_not_called(Winget, :install) do
          @script.unix { @script.install("pkg") }
        end
      end
    end

    test "#macos on macos" do
      with_ruby_platform("darwin") do
        assert_called_with(Brew, :install, %w(pkg)) do
          @script.macos { @script.install("pkg") }
        end
      end
    end

    test "#macos on ubuntu" do
      with_ruby_platform("linux") do
        with_linux_version("Ubuntu") do
          assert_not_called(Apt, :install) do
            @script.macos { @script.install("pkg") }
          end
        end
      end
    end

    test "#macos on fedora" do
      with_ruby_platform("linux") do
        with_linux_version("Red Hat") do
          assert_not_called(Dnf, :install) do
            @script.macos { @script.install("pkg") }
          end
        end
      end
    end

    test "#macos on windows" do
      with_ruby_platform("mingw") do
        assert_not_called(Winget, :install) do
          @script.macos { @script.install("pkg") }
        end
      end
    end

    test "#linux on macos" do
      with_ruby_platform("darwin") do
        assert_not_called(Brew, :install) do
          @script.linux { @script.install("pkg") }
        end
      end
    end

    test "#linux on ubuntu" do
      with_ruby_platform("linux") do
        with_linux_version("Ubuntu") do
          assert_called_with(Apt, :install, %w(pkg)) do
            @script.linux { @script.install("pkg") }
          end
        end
      end
    end

    test "#linux on fedora" do
      with_ruby_platform("linux") do
        with_linux_version("Red Hat") do
          assert_called_with(Dnf, :install, %w(pkg)) do
            @script.linux { @script.install("pkg") }
          end
        end
      end
    end

    test "#linux on windows" do
      with_ruby_platform("mingw") do
        assert_not_called(Winget, :install) do
          @script.linux { @script.install("pkg") }
        end
      end
    end

    test "#windows on macos" do
      with_ruby_platform("darwin") do
        assert_not_called(Brew, :install) do
          @script.windows { @script.install("pkg") }
        end
      end
    end

    test "#windows on ubuntu" do
      with_ruby_platform("linux") do
        with_linux_version("Ubuntu") do
          assert_not_called(Apt, :install) do
            @script.windows { @script.install("pkg") }
          end
        end
      end
    end

    test "#windows on fedora" do
      with_ruby_platform("linux") do
        with_linux_version("Red Hat") do
          assert_not_called(Dnf, :install) do
            @script.windows { @script.install("pkg") }
          end
        end
      end
    end

    test "#windows on windows" do
      with_ruby_platform("mingw") do
        assert_called_with(Winget, :install, %w(Pkg)) do
          @script.windows { @script.install("pkg") }
        end
      end
    end
  end
end

# frozen_string_literal: true

$LOAD_PATH << File.expand_path("../lib", __dir__)
require("bootstrap")
require("minitest/autorun")

module Bootstrap
  module StubHelpers
    def assert_called(object, method_name, times: 1, returns: nil, &block)
      times_called = 0
      counter = proc do
        times_called += 1
        returns
      end
      object.stub(method_name, counter, &block).tap do
        assert_equal(
          times,
          times_called,
          "Expected #{object}.#{method_name} to be called #{times} time(s), but was called #{times_called} time(s)",
        )
      end
    end

    def assert_not_called(object, method_name, &block)
      assert_called(object, method_name, times: 0, &block)
    end

    def assert_called_with(object, method_name, arguments, returns: nil, &block)
      mock = Minitest::Mock.new
      if arguments.all? { |argument| argument.is_a?(Array) }
        arguments.each { |argument| mock.expect(:call, returns, argument) }
      else
        mock.expect(:call, returns, arguments)
      end
      object.stub(method_name, mock, &block)

      mock.verify
    end

    def stub(object, method_name, returns: nil, &block)
      returner = proc { returns }
      object.stub(method_name, returner, &block)
    end

    def stub_const(const_symbol, value, on: Object)
      original_value = on.const_get(const_symbol)
      on.send(:remove_const, const_symbol)
      on.const_set(const_symbol, value)
      yield
    ensure
      on.send(:remove_const, const_symbol)
      on.const_set(const_symbol, original_value)
    end
  end

  module DeclarativeHelpers
    def test(description, &block)
      define_method("test_#{description.gsub(/\s+/, "_")}", &block)
    end

    def setup(&block)
      define_method("setup", &block)
    end

    def teardown(&block)
      define_method("setup", &block)
    end
  end

  module TestHelpers
    def with_ruby_platform(platform, &block)
      stub_const(:RUBY_PLATFORM, platform, &block)
    end

    def with_linux_version(version, &block)
      stub(Environment, :version, returns: version, &block)
    end

    def with_env(**env)
      old_env = ENV.slice(*env.keys)
      ENV.merge!(env)
      yield
    ensure
      ENV.merge!(old_env)
    end

    def file_fixture(path)
      require("pathname")
      Pathname.new(__dir__).join("fixtures", "files", path)
    end
  end

  class TestCase < Minitest::Test
    class << self
      include DeclarativeHelpers
    end
    include StubHelpers
    include TestHelpers

    alias_method :assert_not, :refute
    alias_method :assert_not_predicate, :refute_predicate
    alias_method :assert_not_operator, :refute_operator
    alias_method :assert_not_equal, :refute_equal
  end
end

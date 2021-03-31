# frozen_string_literal: true

module Bootstrap
  class Script
    def initialize
      @environment = Environment.new
      @context = Environment::Matcher.new(:all)
    end

    def install(package)
      @environment.install(package) if @context.match?(@environment)
    end

    def unix
      previous_context = @context
      @context += Environment::Matcher.new(:unix)
      yield
    ensure
      @context = previous_context
    end

    def macos
      previous_context = @context
      @context += Environment::Matcher.new(:macos)
      yield
    ensure
      @context = previous_context
    end

    def linux
      previous_context = @context
      @context += Environment::Matcher.new(:linux)
      yield
    ensure
      @context = previous_context
    end

    def windows
      previous_context = @context
      @context += Environment::Matcher.new(:windows)
      yield
    ensure
      @context = previous_context
    end

    def gui
      previous_context = @context
      @context += Environment::Matcher.new(:none, gui: true)
      yield
    ensure
      @context = previous_context
    end
  end
end

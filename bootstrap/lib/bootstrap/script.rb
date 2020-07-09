# frozen_string_literal: true

module Bootstrap
  class Script
    def initialize
      @environment = Environment.new
      @context = Environment[:all]
    end

    def install(package)
      @environment.install(package) if @context.match?(@environment)
    end

    def unix
      previous_context = @context
      @context = Environment[:unix]
      yield
    ensure
      @context = previous_context
    end

    def macos
      previous_context = @context
      @context = Environment[:macos]
      yield
    ensure
      @context = previous_context
    end

    def linux
      previous_context = @context
      @context = Environment[:linux]
      yield
    ensure
      @context = previous_context
    end

    def windows
      previous_context = @context
      @context = Environment[:windows]
      yield
    ensure
      @context = previous_context
    end
  end
end

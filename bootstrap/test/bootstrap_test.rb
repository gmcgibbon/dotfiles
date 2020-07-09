# frozen_string_literal: true

require("test_helper")

class BootstrapTest < Bootstrap::TestCase
  class << self
    attr_accessor(:context)
  end

  test ".call evaluates file in script context" do
    Bootstrap.call(test_bootstrap)

    assert_instance_of(Bootstrap::Script, context)
  end

  private

  def test_bootstrap
    file_fixture("bootstrap.rb")
  end

  def context
    self.class.context
  end
end

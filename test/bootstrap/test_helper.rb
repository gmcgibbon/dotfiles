
# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "pathname"

require_relative "../../bootstrap/test/test_helper"


module Bootstrap
  class TestCase
    def self.gui?
      !(ENV["DISPLAY"] || ENV["TERM_PROGRAM"]).nil?
    end
  end
end

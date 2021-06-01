# frozen_string_literal: true

require("bootstrap/environment")
require("bootstrap/environment/matcher")
require("bootstrap/package_manager")
require("bootstrap/package")
require("bootstrap/package/source")
require("bootstrap/script")

module Bootstrap
  def self.call(file)
    Script.new.instance_eval(
      File.read(file),
    )
  end
end

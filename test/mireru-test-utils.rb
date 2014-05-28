require "test-unit"
require "test/unit/notify"
require "test/unit/rr"

module MireruTestUtils
  def fixtures_dir
    File.expand_path(File.join(File.dirname(__FILE__), "fixtures"))
  end
end

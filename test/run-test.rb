#!/usr/bin/env ruby

base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$LOAD_PATH.unshift(File.join(base_dir, "lib"))
$LOAD_PATH.unshift(File.join(base_dir, "test"))

require "mireru-test-utils"

require "clutter-test-utils"

exit Test::Unit::AutoRunner.run(true)

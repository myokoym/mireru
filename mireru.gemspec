# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mireru/version'

Gem::Specification.new do |spec|
  spec.name          = "mireru"
  spec.version       = Mireru::VERSION
  spec.authors       = ["Masafumi Yokoyama"]
  spec.email         = ["myokoym@gmail.com"]
  spec.summary       = %q{Keyboard friendly multitype file viewer by Ruby/GTK3.}
  spec.description   = %q{Mireru is a keyboard friendly file viewer by Ruby/GTK3. It can handle a variety of file types (Picture, Text, PDF, Video and etc.).}

  spec.homepage      = "https://github.com/myokoym/mireru"
  spec.license       = "GPLv2 or later"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("gtksourceview3", ">= 2.2.0")
  spec.add_runtime_dependency("clutter-gtk", ">= 2.2.0")
  spec.add_runtime_dependency("clutter-gstreamer", ">= 2.2.0")
  spec.add_runtime_dependency("poppler", ">= 2.2.0")
  spec.add_runtime_dependency("rsvg2", ">= 2.2.0")
  spec.add_runtime_dependency("hexdump")
  spec.add_runtime_dependency("chupa-text")
  spec.add_runtime_dependency("chupa-text-decomposer-html")
  spec.add_runtime_dependency("chupa-text-decomposer-pdf")
  spec.add_runtime_dependency("chupa-text-decomposer-libreoffice")

  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("test-unit-notify")
  spec.add_development_dependency("test-unit-rr")
  spec.add_development_dependency("bundler", "~> 1.6")
  spec.add_development_dependency("rake")
end

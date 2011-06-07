# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "snortor/version"

Gem::Specification.new do |s|
  s.name        = "snortor"
  s.version     = Snortor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bernhard Katzmarski"]
  s.email       = ["bkatzm@tzi.de"]
  s.homepage    = "http://www.fidius.me"
  s.summary     = %q{SUMMARY HERE}
  s.description = %q{Description here}

  s.rubyforge_project = "snortor"

  s.add_dependency "snort-rule", ">= 0.0.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

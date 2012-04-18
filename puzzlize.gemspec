# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "puzzlize/version"

Gem::Specification.new do |s|
  s.name        = "puzzlize"
  s.version     = Puzzlize::VERSION
  s.authors     = ["Ziemek Wolski"]
  s.email       = ["ziemek.wolski@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Gem created a puzzle using images from a predefined image on a model.}
  s.description = %q{This gem is made up off two libraries. A cutter library - determines all the points to cut. Rmagick rapper, which actually cuts up the images.}

  s.rubyforge_project = "puzzlize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "paperclip"
  s.add_runtime_dependency "rmagick"
  s.add_runtime_dependency "supermodel"
end

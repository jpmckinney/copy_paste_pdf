# -*- encoding: utf-8 -*-
require File.expand_path('../lib/copy_paste_pdf/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "copy_paste_pdf"
  s.version     = CopyPastePDF::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James McKinney"]
  s.homepage    = "http://github.com/jpmckinney/copy_paste_pdf"
  s.summary     = %q{Converts PDF to CSV by copy-pasting from Apple's Preview to Microsoft Excel}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('coveralls')
  s.add_development_dependency('json', '~> 1.7.7') # to silence coveralls warning
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.10')
end

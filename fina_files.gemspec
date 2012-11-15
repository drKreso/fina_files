# -*- encoding: utf-8 -*-
require File.expand_path('../lib/fina_files/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["drKreso"]
  gem.email         = ["kresimir.bojcic@gmail.com"]
  gem.description   = %q{FINA formati na jednom mjestu}
  gem.summary       = %q{Podrska za rad sa fina datotekama}
  gem.homepage      = "https://github.com/drKreso/fina_files"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fina_files"
  gem.require_paths = ["lib"]
  gem.version       = FinaFiles::VERSION
end

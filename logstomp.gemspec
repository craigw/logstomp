# -*- encoding: utf-8 -*-
require File.expand_path('../lib/logstomp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Craig R Webster"]
  gem.email         = ["craig@barkingiguana.com"]
  gem.description   = %q{svlogd processor to send logs to Stomp destination}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "logstomp"
  gem.require_paths = ["lib"]
  gem.version       = Logstomp::VERSION

  gem.add_runtime_dependency 'tai64', '~> 0.0.3'
  gem.add_runtime_dependency 'stomp'
end

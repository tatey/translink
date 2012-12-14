# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'translink/version'

Gem::Specification.new do |s|
  s.name                 = 'translink'
  s.version              = Translink::VERSION
  s.platform             = Gem::Platform::RUBY
  s.authors              = ['Tate Johnson']
  s.email                = ['tate@tatey.com']
  s.homepage             = 'https://github.com/tatey/translink'
  s.summary              = %q{Scrapes public transport data from TransLink into GTFS}
  s.description          = %q{Scrapes public transport data from TransLink into GTFS}

  s.rubyforge_project = 'translink'

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'dm-core', '~> 1.2.0'
  s.add_runtime_dependency 'dm-migrations', '~> 1.2.0'
  s.add_runtime_dependency 'dm-sqlite-adapter', '~> 1.2.0'
  s.add_runtime_dependency 'mechanize', '~> 2.5.1'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake', '~> 0.9.2'
  s.add_development_dependency 'webmock', '~> 1.7.8'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end

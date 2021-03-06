# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fedex_parcels_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "fedex_parcels_tracker"
  spec.version       = FedexParcelsTracker::VERSION
  spec.authors       = ["Filip Stybel", "Michal Andros"]
  spec.email         = ["filip.stybel@justcode.io", "michalandros@gmail.com"]

  spec.summary       = %q{Track changes to Your parcels when using Fedex services}
  spec.description   = %q{Check your parcel status and history by providing a fedex parcel tracking number}
  spec.homepage      = "https://github.com/justcodeio/fedex_parcels_tracker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.11', '>= 1.11.2'
  spec.add_development_dependency 'rake', '~> 12.3', '>= 12.3.1'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'pry'
  spec.add_runtime_dependency 'savon', '~> 2.12.0'
end

require_relative './lib/manufacturable/version'

Gem::Specification.new do |spec|
  spec.name          = "manufacturable"
  spec.version       = Manufacturable::VERSION
  spec.authors       = ["Alan Ridlehoover", "Fito von Zastrow"]
  spec.email         = ["administators@firsttry.software"]

  spec.summary       = %q{Manufacturable is a factory that builds self-registering objects.}
  spec.description   = %q{Manufacturable is a factory that builds self-registering objects. It leverages self-registration to move factory setup from case statements, hashes, and configuration files to a simple DSL within the instantiable classes themselves. Giving classes the responsibility of registering themselves with the factory does two things. It allows the factory to be extended without modification. And, it leaves the factory with only one responsibility: building objects.}
  spec.homepage      = "https://github.com/first-try-software/manufacturable"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/first-try-software/manufacturable/issues",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/first-try-software/manufacturable"
  }

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|assets)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~>0.4"
  spec.add_development_dependency "simplecov", "~>0.17.0"
end

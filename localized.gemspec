Gem::Specification.new do |s|
  s.name        = 'localized'
  s.author      = 'Paul Hepworth'
  s.email       = 'paul<dot>hepworth<at>peppyheppy<dot>com'
  s.version     = '0.0.8'
  s.homepage    = 'https://github.com/peppyheppy/localized'
  s.date        = '2011-07-09'
  s.summary     = "A ruby on rails gem that provides locale setting support through the subdomain (in a box)"
  s.description = "This gem allows you to set locale using a subdomain and url helper support for switching sites."
  s.files       = s.files = `git ls-files`.split("\n")
  # s.add_runtime_dependency "psych"
  s.add_runtime_dependency "rails", ">= 3.0"
  s.add_runtime_dependency "bitfields", ">= 0.4.0"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "rspec", "2.6.0"
  s.add_development_dependency "rspec-rails", "2.6.0"
  s.add_development_dependency "generator_spec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "guard-compass"
  s.add_development_dependency "guard-spork", "~> 0.3"
  s.add_development_dependency "guard-rspec", "~> 0.5"
  s.add_development_dependency "growl"
end


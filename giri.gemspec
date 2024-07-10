lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "giri/version"

Gem::Specification.new do |s|
  s.name         = "giri"
  s.version      = Giri::VERSION
  s.summary      = "Giri"
  s.description  = "Giri"
  s.authors      = ["metheglin"]
  s.email        = "pigmybank@gmail.com"
  s.files        = Dir["{lib}/**/*.rb", "{lib}/**/*.rake", "bin/*", "LICENSE", "*.md"]
  s.homepage     = "https://rubygems.org/gems/giri"
  # s.executables  = %w(giri)
  s.require_path = 'lib'
  s.license      = "MIT"

  s.required_ruby_version = ">= 2.7"
  s.add_dependency "rake", "~> 13.0"
  s.add_dependency "hashie"
end
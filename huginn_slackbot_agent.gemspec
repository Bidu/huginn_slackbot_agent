# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "huginn_slackbot_agent"
  spec.version       = '0.1'
  spec.authors       = ["Renato Menegasso"]
  spec.email         = ["renato.menegasso@bidu.com.br"]

  spec.summary       = %q{Huginn agent to send messages into slack as a bot.}
  spec.description   = %q{Write a longer description or delete this line.}

  spec.homepage      = "https://github.com/[my-github-username]/huginn_slackbot_agent"


  spec.files         = Dir['LICENSE.txt', 'lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "huginn_agent"
  spec.add_runtime_dependency "slack-ruby-client"
end

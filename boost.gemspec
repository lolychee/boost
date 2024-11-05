# frozen_string_literal: true

require_relative "lib/boost/version"

Gem::Specification.new do |spec|
  spec.name = "boost.rb"
  spec.version = Boost::VERSION
  spec.authors = ["lychee xing"]
  spec.email = ["lolychee@gmail.com"]

  spec.summary = "Boost helps you write simpler, more modular, and flexible Ruby code."
  # spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://github.com/lolychee/boost"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/lolychee/boost"
  spec.metadata["changelog_uri"] = "https://github.com/lolychee/boost/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", ">= 2.7.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

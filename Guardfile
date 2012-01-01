group 'backend' do
  guard 'bundler' do
    watch('Gemfile')
    watch('Gemfile.lock')
  end

  guard 'rspec', rvm: '1.9.2', cli: "--color -d --format nested --color --profile", :bundle => false do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{spec/(.*)_spec.rb})
    watch(%r{lib/(.*)\.rb})          { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')     { "spec" }
  end
end

